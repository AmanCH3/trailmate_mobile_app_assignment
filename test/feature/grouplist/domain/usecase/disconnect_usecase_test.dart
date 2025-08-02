// 1. Import necessary packages
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/disconnect_usecase.dart';

// 3. Create a mock class for the repository
class MockChatRepository extends Mock implements IChatRepository {}

void main() {
  // 4. Declare variables for the use case and mock repository
  late DisconnectUseCase usecase;
  late MockChatRepository mockChatRepository;

  // 5. The setUp function runs before each test
  setUp(() {
    mockChatRepository = MockChatRepository();
    usecase = DisconnectUseCase(mockChatRepository);
  });

  // 6. Define a sample failure for the error case
  final tSocketFailure = ApiFailure(
    message: 'Could not disconnect from the server',
    statusCode: 500,
  );

  // 7. Group related tests together
  group('DisconnectUseCase', () {
    test(
      'should call disconnect on the repository and return Right(null) on success',
      () async {
        // Arrange: Set up the mock repository to return a successful result.
        // For a void return type, success is represented as Right(null).
        when(
          () => mockChatRepository.disconnect(),
        ).thenAnswer((_) async => const Right(null));

        // Act: Execute the use case.
        final result = await usecase();

        // Assert: Check that the result is Right(null).
        expect(result, const Right(null));

        // Verify that the repository's disconnect method was called exactly once.
        verify(() => mockChatRepository.disconnect()).called(1);

        // Ensure no other methods on the mock were called.
        verifyNoMoreInteractions(mockChatRepository);
      },
    );

    test(
      'should return a Failure when the repository call is unsuccessful',
      () async {
        // Arrange: Set up the mock to return a Failure.
        when(
          () => mockChatRepository.disconnect(),
        ).thenAnswer((_) async => Left(tSocketFailure));

        // Act: Execute the use case.
        final result = await usecase();

        // Assert: Check that the result is the Failure we defined.
        expect(result, Left(tSocketFailure));

        // Verify that the repository's disconnect method was still called.
        verify(() => mockChatRepository.disconnect()).called(1);

        verifyNoMoreInteractions(mockChatRepository);
      },
    );
  });
}
