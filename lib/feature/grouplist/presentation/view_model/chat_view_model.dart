// FILE: lib/feature/grouplist/presentation/view_model/chat_view_model.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/disconnect_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/get_message_history_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/listen_new_message_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/request_to_join_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/send_message_usecase.dart';
import 'package:equatable/equatable.dart'; // Make sure Equatable is imported for SendMessageParams if needed

import 'chat_event.dart';
import 'chat_state.dart';

class ChatViewModel extends Bloc<ChatEvent, ChatState> {
  final GetMessageHistoryUseCase _getMessageHistory;
  final SendMessageUseCase _sendMessage;
  final ListenForNewMessageUseCase _listenForNewMessage;
  final RequestToJoinGroupUseCase _joinGroup;
  final DisconnectUseCase _disconnect;

  StreamSubscription<MessageEntity>? _messageSubscription;

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
    // 1. Immediately move to a 'connecting' state. The UI will show a loader.
    emit(
      ChatLoading(
        messages: const [],
        connectionStatus: ConnectionStatus.connecting,
      ),
    );

    // 2. Start listening for new messages. This is the key to knowing when we are connected.
    //    We pass the emitter so _listenForMessages can change the state directly.
    _listenForMessages(emit);

    // 3. Trigger the connection and join the group.
    _joinGroup(RequestToJoinGroupParams(groupId: event.groupId));

    // 4. Fetch the message history.
    final historyResult = await _getMessageHistory(
      GetMessageHistoryParams(groupId: event.groupId),
    );

    historyResult.fold(
      (failure) {
        // If history fails, emit a failure state.
        emit(ChatFailure(error: failure.message, messages: const []));
      },
      (history) {
        // If history loads BUT we are still not connected, stay in ChatLoading.
        // If we are already connected (from the listener), move to ChatSuccess.
        if (state.connectionStatus == ConnectionStatus.connected) {
          emit(ChatSuccess(messages: history));
        } else {
          emit(
            ChatLoading(
              messages: history,
              connectionStatus: ConnectionStatus.connecting,
            ),
          );
        }
      },
    );
  }

  void _listenForMessages(Emitter<ChatState> emit) async {
    await _messageSubscription?.cancel();
    final result = await _listenForNewMessage();

    result.fold(
      (failure) {
        // If we can't even start listening, it's a hard failure.
        emit(ChatFailure(error: failure.message, messages: state.messages));
      },
      (stream) {
        _messageSubscription = stream.listen(
          (newMessage) {
            // THE MOST IMPORTANT PART: The first time we receive a message
            // (even our own join confirmation if the server sends one, or the first real message),
            // we know for sure the connection is live.
            if (state.connectionStatus != ConnectionStatus.connected) {
              // Move to connected state with the current messages
              emit(ChatSuccess(messages: state.messages));
            }
            // Then, add the event to update the message list.
            add(NewMessageReceived(message: newMessage));
          },
          onError: (error) {
            emit(
              ChatFailure(
                error: "Connection error: $error",
                messages: state.messages,
              ),
            );
          },
        );
      },
    );
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (event.content.trim().isEmpty) return;
    if (state.connectionStatus != ConnectionStatus.connected) {
      print("Cannot send message, not connected.");
      return;
    }

    final params = SendMessageParams(
      text: event.content,
      groupId: event.groupId,
      senderId: event.senderId,
    );

    await _sendMessage(params);
    // We don't change state here. The message will arrive via the stream
    // and be handled by _onNewMessageReceived, which is the single source of truth.
  }

  void _onNewMessageReceived(
    NewMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    // This is the single source of truth for updating the message list.
    final updatedMessages = [event.message, ...state.messages];
    emit(ChatSuccess(messages: updatedMessages));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _disconnect();
    return super.close();
  }
}
