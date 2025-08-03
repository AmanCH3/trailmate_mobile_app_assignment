import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/usecase/get_chat_reply_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_state.dart';

class ChatBloc extends Bloc<BotEvent, BotState> {
  final GetChatReplyUsecase getChatReplyUsecase;

  ChatBloc({required this.getChatReplyUsecase}) : super(ChatInitial()) {
    on<SendChatMessage>(_onSendChatMessage);
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<BotState> emit,
  ) async {
    // 1. Create the user's message entity
    final userMessage = ChatMessageEntity(
      role: ChatRole.user,
      text: event.query,
    );

    // 2. Get the current history from the state
    final currentHistory = List<ChatMessageEntity>.from(state.messages);

    // 3. Emit a loading state immediately with the user's new message
    // This provides instant UI feedback.
    emit(ChatLoading(messages: [...currentHistory, userMessage]));

    // 4. Call the usecase with the query and the *original* history
    final result = await getChatReplyUsecase(
      GetChatReplyParams(query: event.query, history: currentHistory),
    );

    // 5. Handle the result (success or failure)
    result.fold(
      (failure) {
        // On failure, create an error message entity
        final errorReply = ChatMessageEntity(
          role: ChatRole.model,
          text: "Oops! Something went wrong. ${failure.message}",
        );
        // Emit an error state, keeping all previous messages
        emit(
          ChatError(
            errorMessage: failure.message,
            messages: [...state.messages, errorReply],
          ),
        );
      },
      (botReplyEntity) {
        // On success, emit the loaded state with the bot's reply
        emit(ChatLoaded(messages: [...state.messages, botReplyEntity]));
      },
    );
  }
}
