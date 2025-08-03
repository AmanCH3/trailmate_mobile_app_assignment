// 1. Import necessary packages
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/group_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/request_to_join_usecase.dart';

// 3. Create mock classes for ALL dependencies
class MockGroupRepository extends Mock implements IGroupRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  // 4. Declare variables for the use case and all mock dependencies
  late RequestToJoinGroupUseCase usecase;
  late MockGroupRepository mockGroupRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  // 5. Register fallback value for custom parameter objects
  // This is crucial for mocktail when using argument matchers like `any()`
  // with custom classes.
  setUpAll(() {
    registerFallbackValue(
      const RequestToJoinGroupParams(groupId: 'any_group_id'),
    );
  });

  // 6. The setUp function runs before each test
  setUp(() {
    mockGroupRepository = MockGroupRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = RequestToJoinGroupUseCase(
      groupRepository: mockGroupRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  // 7. Define test data to be reused
  const tParams = RequestToJoinGroupParams(
    groupId: 'group-123',
    message: 'I would love to join!',
  );
  const tToken = 'sample-jwt-token';

  final tApiFailure = ApiFailure(statusCode: 403, message: 'Not authorized');
  final tCacheFailure = ApiFailure(
    message: 'Could not retrieve token',
    statusCode: null,
  );

  // 8. Group related tests together
  group('RequestToJoinGroupUseCase', () {
    test(
      'should get token and call repository, returning Right(null) on full success',
      () async {
        // Arrange: Set up both mocks for the "happy path"
        // 1. Token retrieval is successful
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        // 2. Repository call is successful
        when(
          () => mockGroupRepository.requestToJoinGroup(tParams, tToken),
        ).thenAnswer((_) async => const Right(null));

        // Act: Execute the use case
        final result = await usecase(tParams);

        // Assert: Check the final result
        expect(result, const Right(null));

        // Verify that the dependencies were called in the correct order
        verifyInOrder([
          () => mockTokenSharedPrefs.getToken(),
          () => mockGroupRepository.requestToJoinGroup(tParams, tToken),
        ]);

        // Ensure no other unexpected interactions
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockGroupRepository);
      },
    );

    test('should return a Failure when the repository call fails', () async {
      // Arrange: Set up the token to succeed but the repository to fail
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));
      when(
        () => mockGroupRepository.requestToJoinGroup(tParams, tToken),
      ).thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await usecase(tParams);

      // Assert: The final result should be the failure from the repository
      expect(result, Left(tApiFailure));

      // Verify that both mocks were still called
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(
        () => mockGroupRepository.requestToJoinGroup(tParams, tToken),
      ).called(1);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockGroupRepository);
    });

    test(
      'should return a Failure and NOT call the repository if token retrieval fails',
      () async {
        // Arrange: Set up the token retrieval to fail at the first step
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => Left(tCacheFailure));

        // Act
        final result = await usecase(tParams);

        // Assert: The result should be the failure from the token retrieval
        expect(result, Left(tCacheFailure));

        // Verify that token retrieval was attempted
        verify(() => mockTokenSharedPrefs.getToken()).called(1);

        // CRUCIAL: Verify that the repository was NEVER called because the logic bailed out early.
        verifyNever(() => mockGroupRepository.requestToJoinGroup(any(), any()));

        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockGroupRepository);
      },
    );
  });
}
