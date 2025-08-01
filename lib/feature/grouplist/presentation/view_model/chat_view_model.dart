// lib/feature/grouplist/presentation/view_model/chat_view_model.dart

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
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<NewMessageReceived>(_onNewMessageReceived);
  }

  void _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) async {
    // 1. Emit loading state.
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

    // This variable will hold the loaded history.
    List<MessageEntity> messageHistory = [];

    // 4. Fetch the message history IN PARALLEL.
    final historyFuture = _getMessageHistory(
      GetMessageHistoryParams(groupId: event.groupId),
    ).then((result) {
      result.fold(
        (failure) {
          // If history fails, we'll handle it later. For now, just log or store error.
          // We don't emit a failure state yet, because the connection might still be good.
          print("Failed to load history: ${failure.message}");
        },
        (history) {
          messageHistory = history;
        },
      );
    });

    // 5. Handle the stream connection result.
    await streamResult.fold(
      (failure) async {
        // If the connection itself fails, emit a failure state.
        emit(ChatFailure(error: failure.message, messages: state.messages));
      },
      (stream) async {
        // SUCCESS! The stream is ready. We are "connected".
        // Now wait for the history to finish loading before we emit the final success state.
        await historyFuture;

        // 6. Emit the SUCCESS state with history and a CONNECTED status.
        emit(ChatSuccess(messages: messageHistory));

        // 7. Now, subscribe to the stream for any NEW messages.
        _messageSubscription = stream.listen(
          (newMessage) {
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

    // Check against ChatSuccess state type, not connectionStatus, for robustness.
    if (state is! ChatSuccess) {
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
    // We only add new messages if the state is already successful.
    if (state is ChatSuccess) {
      final updatedMessages = [event.message, ...state.messages];
      emit(ChatSuccess(messages: updatedMessages));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _disconnect();
    return super.close();
  }
}
