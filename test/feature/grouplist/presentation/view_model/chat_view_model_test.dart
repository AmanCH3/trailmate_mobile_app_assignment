import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/sender_entity.dart'; // Assuming this path
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/disconnect_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/get_message_history_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/listen_new_message_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/send_message_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_view_model.dart';

// --- Mocks for all Dependencies ---
class MockGetMessageHistoryUseCase extends Mock
    implements GetMessageHistoryUseCase {}

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}

class MockListenForNewMessageUseCase extends Mock
    implements ListenForNewMessageUseCase {}

class MockDisconnectUseCase extends Mock implements DisconnectUseCase {}

class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

// Mock for complex param objects
class MockGetMessageHistoryParams extends Mock
    implements GetMessageHistoryParams {}

class MockListenForNewMessageParams extends Mock
    implements ListenForNewMessageParams {}

class MockSendMessageParams extends Mock implements SendMessageParams {}

// Mock for the SenderEntity since it's part of our test data
class MockSenderEntity extends Mock implements SenderEntity {}

void main() {
  late ChatViewModel chatViewModel;
  late MockGetMessageHistoryUseCase mockGetMessageHistory;
  late MockSendMessageUseCase mockSendMessage;
  late MockListenForNewMessageUseCase mockListenForNewMessage;
  late MockDisconnectUseCase mockDisconnect;

  // --- Test Data ---
  const tGroupId = 'group-123';
  const tUserId = 'user-456';

  // FIX 1: Create a valid SenderEntity object.
  const tSender1 = SenderEntity(name: 'User One', senderId: 'user-1');
  const tSender2 = SenderEntity(name: 'Current User', senderId: tUserId);

  // FIX 2: Remove `const` and use the valid SenderEntity.
  final tHistory = [
    MessageEntity(
      text: 'Hello',
      senderId: 'user-1',
      messageId: 'msg-1',
      groupId: tGroupId,
      sender: tSender1, // <-- Use a valid object
      timestamp: DateTime.parse('2023-10-01T12:00:00Z'),
    ),
  ];
  final tNewMessage = MessageEntity(
    text: 'Hi there!',
    senderId: tUserId,
    messageId: 'msg-2',
    groupId: tGroupId,
    sender: tSender2, // <-- Use a valid object
    timestamp: DateTime.parse('2023-10-01T12:01:00Z'),
  );
  final tFailure = MockFailure('Connection failed');

  // --- Test Stream Controller ---
  late StreamController<MessageEntity> messageStreamController;

  setUpAll(() {
    // Register fallback values for custom param objects used in mocks
    registerFallbackValue(const GetMessageHistoryParams(groupId: ''));
    registerFallbackValue(const ListenForNewMessageParams(groupId: ''));
    registerFallbackValue(
      const SendMessageParams(text: '', groupId: '', senderId: ''),
    );
  });

  setUp(() {
    mockGetMessageHistory = MockGetMessageHistoryUseCase();
    mockSendMessage = MockSendMessageUseCase();
    mockListenForNewMessage = MockListenForNewMessageUseCase();
    mockDisconnect = MockDisconnectUseCase();
    messageStreamController = StreamController<MessageEntity>.broadcast();

    chatViewModel = ChatViewModel(
      getMessageHistory: mockGetMessageHistory,
      sendMessage: mockSendMessage,
      listenForNewMessage: mockListenForNewMessage,
      disconnect: mockDisconnect,
    );
  });

  tearDown(() {
    messageStreamController.close();
    chatViewModel.close();
  });

  group('ChatViewModel', () {
    group('InitializeChat', () {
      const tInitializeEvent = InitializeChat(
        groupId: tGroupId,
        currentUserId: tUserId,
      );

      group('Lifecycle (close)', () {
        test(
          'calls DisconnectUseCase and cancels subscription on close',
          () async {
            when(
              () => mockListenForNewMessage(any()),
            ).thenReturn(Right(messageStreamController.stream));
            when(
              () => mockGetMessageHistory(any()),
            ).thenAnswer((_) async => Right(tHistory));
            when(
              () => mockDisconnect(),
            ).thenAnswer((_) async => const Right(null));

            chatViewModel.add(
              const InitializeChat(groupId: tGroupId, currentUserId: tUserId),
            );
            await pumpEventQueue();

            await chatViewModel.close();

            verify(() => mockDisconnect()).called(1);
            expect(messageStreamController.hasListener, isFalse);
          },
        );
      });
    });
  });
}
