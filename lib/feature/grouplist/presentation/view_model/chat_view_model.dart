import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/disconnect_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/get_message_history_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/listen_new_message_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/request_to_join_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/send_message_usecase.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatViewModel extends Bloc<ChatEvent, ChatState> {
  final GetMessageHistoryUseCase _getMessageHistory;
  final SendMessageUseCase _sendMessage;
  final ListenForNewMessageUseCase _listenForNewMessage;
  final RequestToJoinGroupUseCase _joinGroup;
  final DisconnectUseCase _disconnect;

  StreamSubscription<MessageEntity>? _messageSubscription;
  String _groupId = '';
  String _currentUserId = '';

  ChatViewModel({
    required GetMessageHistoryUseCase getMessageHistory,
    required SendMessageUseCase sendMessage,
    required ListenForNewMessageUseCase listenForNewMessage,
    required RequestToJoinGroupUseCase joinGroup,
    required DisconnectUseCase disconnect,
  }) : _getMessageHistory = getMessageHistory,
       _sendMessage = sendMessage,
       _listenForNewMessage = listenForNewMessage,
       _joinGroup = joinGroup,
       _disconnect = disconnect,
       super(ChatInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<NewMessageReceived>(_onNewMessageReceived);
  }

  void _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) async {
    // Preserve existing messages during loading
    emit(ChatLoading(messages: state.messages));

    // Store IDs for later use (e.g., sending messages)
    _groupId = event.groupId;
    _currentUserId = event.currentUserId;

    // 1. Join the group socket room
    _joinGroup(RequestToJoinGroupParams(groupId: _groupId));
    _listenForMessages();

    // 3. Fetch historical messages
    final historyResult = await _getMessageHistory(
      GetMessageHistoryParams(groupId: _groupId),
    );

    historyResult.fold(
      (failure) =>
          emit(ChatFailure(error: failure.message, messages: state.messages)),
      (history) => emit(ChatSuccess(messages: history)),
    );
  }

  void _listenForMessages() async {
    final result = await _listenForNewMessage();
    result.fold(
      (failure) {
        // If listening fails, emit a failure state
        addError(failure.message);
        emit(ChatFailure(error: failure.message, messages: state.messages));
      },
      (stream) {
        _messageSubscription?.cancel(); // Ensure no duplicate subscriptions
        _messageSubscription = stream.listen(
          (newMessage) {
            // Add an event to the BLoC when a new message arrives
            add(NewMessageReceived(message: newMessage));
          },
          onError: (error) {
            addError(error);
            emit(
              ChatFailure(
                error: "Error receiving messages: $error",
                messages: state.messages,
              ),
            );
          },
        );
      },
    );
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (event.text.trim().isEmpty) return;

    final params = SendMessageParams(
      text: event.text,
      groupId: _groupId,
      senderId: _currentUserId,
    );

    final result = await _sendMessage(params);

    result.fold(
      (failure) {
        // If sending fails, emit a failure state but keep existing messages
        emit(ChatFailure(error: failure.message, messages: state.messages));
      },
      (_) {
        // On success, do nothing. The message will arrive via the stream
        // and be handled by `NewMessageReceived`, preventing duplicates.
      },
    );
  }

  void _onNewMessageReceived(
    NewMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final updatedMessages = List<MessageEntity>.from(state.messages);
    updatedMessages.insert(0, event.message);
    emit(ChatSuccess(messages: updatedMessages));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _disconnect(); // Disconnect from socket on BLoC disposal
    return super.close();
  }
}
