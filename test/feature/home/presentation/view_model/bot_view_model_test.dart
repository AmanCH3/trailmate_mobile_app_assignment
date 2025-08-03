import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/usecase/get_chat_reply_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_view_model.dart';

class MockGetChatReplyUsecase extends Mock implements GetChatReplyUsecase {}

class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

void main() {
  late ChatBloc chatBloc;
  late MockGetChatReplyUsecase mockGetChatReplyUsecase;

  const tUserQuery = 'What gear do I need for a day hike?';
  const tBotReplyText = 'You will need a backpack, water, snacks, and a map.';

  final tWelcomeMessage = ChatInitial().messages.first;

  const tUserMessage = ChatMessageEntity(role: ChatRole.user, text: tUserQuery);

  const tBotReply = ChatMessageEntity(
    role: ChatRole.model,
    text: tBotReplyText,
  );

  const tErrorMessage = "Oops! Something went wrong. Test error";

  final tErrorReply = const ChatMessageEntity(
    role: ChatRole.model,
    text: tErrorMessage,
  );

  final tFailure = MockFailure('Test error');

  setUpAll(() {
    registerFallbackValue(const GetChatReplyParams(query: '', history: []));
  });

  setUp(() {
    mockGetChatReplyUsecase = MockGetChatReplyUsecase();
    chatBloc = ChatBloc(getChatReplyUsecase: mockGetChatReplyUsecase);
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc', () {
    test('initial state is ChatInitial with a welcome message', () {
      expect(chatBloc.state, ChatInitial());
      expect(chatBloc.state.messages.length, 1);
      expect(chatBloc.state.messages.first.role, ChatRole.model);
    });

    group('SendChatMessage', () {
      blocTest<ChatBloc, BotState>(
        'emits [ChatLoading, ChatLoaded] on successful reply',
        setUp: () {
          when(
            () => mockGetChatReplyUsecase(any()),
          ).thenAnswer((_) async => const Right(tBotReply));
        },
        build: () => chatBloc,
        act: (bloc) => bloc.add(const SendChatMessage(query: tUserQuery)),
        expect:
            () => [
              ChatLoading(messages: [tWelcomeMessage, tUserMessage]),
              ChatLoaded(messages: [tWelcomeMessage, tUserMessage, tBotReply]),
            ],
        verify: (_) {
          verify(
            () => mockGetChatReplyUsecase(
              GetChatReplyParams(query: tUserQuery, history: [tWelcomeMessage]),
            ),
          ).called(1);
        },
      );

      blocTest<ChatBloc, BotState>(
        'emits [ChatLoading, ChatError] on failed reply',
        setUp: () {
          when(
            () => mockGetChatReplyUsecase(any()),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => chatBloc,
        act: (bloc) => bloc.add(const SendChatMessage(query: tUserQuery)),
        expect:
            () => [
              ChatLoading(messages: [tWelcomeMessage, tUserMessage]),
              ChatError(
                errorMessage: tFailure.message,
                messages: [tWelcomeMessage, tUserMessage, tErrorReply],
              ),
            ],
        verify: (_) {
          verify(
            () => mockGetChatReplyUsecase(
              GetChatReplyParams(query: tUserQuery, history: [tWelcomeMessage]),
            ),
          ).called(1);
        },
      );
    });
  });
}
