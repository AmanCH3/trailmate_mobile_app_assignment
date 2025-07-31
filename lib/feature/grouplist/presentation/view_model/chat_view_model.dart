import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/disconnect_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/get_message_history_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/send_message_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart';

import '../../domain/usecase/listen_new_message_usecase.dart';

class ChatViewModel extends Bloc<ChatEvent, ChatState> {
  final GetMessageHistoryUseCase _getMessageHistory;
  final SendMessageUseCase _sendMessage;
  final ListenForNewMessageUseCase _listenForNewMessage;
  final DisconnectUseCase _disconnect;

  StreamSubscription<MessageEntity>? _messageSubscription;

  ChatViewModel({
    required GetMessageHistoryUseCase getMessageHistory,
    required SendMessageUseCase sendMessage,
    required ListenForNewMessageUseCase listenForNewMessage,
    required DisconnectUseCase disconnect,
  }) : _getMessageHistory = getMessageHistory,
       _sendMessage = sendMessage,
       _listenForNewMessage = listenForNewMessage,
       _disconnect = disconnect,
       super(ChatInitial()) {
    // Start with your ChatInitial state
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<NewMessageReceived>(_onNewMessageReceived);
  }

  void _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) async {
    // 1. Immediately emit your ChatLoading state.
    emit(
      const ChatLoading(
        messages: [],
        connectionStatus: ConnectionStatus.connecting,
      ),
    );

    // 2. Cancel any previous subscription.
    await _messageSubscription?.cancel();

    // 3. Start the connection and listening process.
    final streamResult = _listenForNewMessage(
      ListenForNewMessageParams(groupId: event.groupId),
    );

    streamResult.fold(
      (failure) {
        // If we can't even start listening, emit ChatFailure.
        emit(ChatFailure(error: failure.message, messages: state.messages));
      },
      (stream) {
        // 4. Subscribe to the stream of new messages.
        _messageSubscription = stream.listen(
          (newMessage) {
            // The first message proves the connection is live.
            if (state.connectionStatus != ConnectionStatus.connected) {
              // Once connected, transition to the ChatSuccess state.
              // We pass the current messages so they don't disappear from the UI.
              emit(ChatSuccess(messages: state.messages));
            }
            // Trigger the event to add the new message to the list.
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

    // 5. In parallel, fetch the message history.
    final historyResult = await _getMessageHistory(
      GetMessageHistoryParams(groupId: event.groupId),
    );

    historyResult.fold(
      (failure) {
        // If history fails, emit a failure state.
        emit(ChatFailure(error: failure.message, messages: state.messages));
      },
      (history) {
        // History loaded successfully. Now update the state with the new messages.
        // We must check the current state to emit the correct subclass.
        if (state.connectionStatus == ConnectionStatus.connected) {
          // If we are already connected, emit a new ChatSuccess state.
          emit(ChatSuccess(messages: history));
        } else {
          // If we are still connecting, emit a new ChatLoading state.
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

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (event.content.trim().isEmpty) return;

    if (state.connectionStatus != ConnectionStatus.connected) {
      print("Cannot send message, not connected.");
      return;
    }

    await _sendMessage(
      SendMessageParams(
        text: event.content,
        groupId: event.groupId,
        senderId: event.senderId,
      ),
    );
    // No state change here. The new message will arrive via the stream.
  }

  void _onNewMessageReceived(
    NewMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    // Add the new message to the beginning of the list.
    final updatedMessages = [event.message, ...state.messages];
    // Emit the ChatSuccess state with the updated list.
    // This assumes that if we are receiving messages, the connection is successful.
    emit(ChatSuccess(messages: updatedMessages));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _disconnect();
    return super.close();
  }
}
