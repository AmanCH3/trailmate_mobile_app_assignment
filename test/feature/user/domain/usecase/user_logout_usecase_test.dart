// Imports for testing
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

// Imports from your project
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_logout_usecase.dart';
import 'package:equatable/equatable.dart';

// --- MOCK CLASS ---
// We only need to mock TokenSharedPrefs for this use case.
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  // Declare the variables that will hold the use case and its mock dependency.
  late UserLogoutUseCase usecase;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  // This `setUp` function runs before each individual test.
  setUp(() {
    // Instantiate a new mock object for each test to ensure a clean state.
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    // Instantiate the use case with the mock.
    usecase = UserLogoutUseCase(tokenSharedPrefs: mockTokenSharedPrefs);
  });

  // Group tests for the UserLogoutUseCase.
  group('UserLogoutUseCase', () {
    const tFailure = ApiFailure(
      message: 'Could not clear token',
      statusCode: 500,
    );

    test(
      'should call TokenSharedPrefs.clearToken and return Right(null) on success',
      () async {
        when(
          () => mockTokenSharedPrefs.clearToken(),
        ).thenAnswer((_) async => const Right(null));

        // ACT: Execute the use case's call method.
        // It takes no parameters, so we call it with empty parentheses.
        final result = await usecase();

        // ASSERT: Verify the outcomes.
        // 1. The result should be Right(null).
        expect(result, const Right(null));

        // 2. Verify that clearToken() was called on the mock exactly once.
        verify(() => mockTokenSharedPrefs.clearToken()).called(1);

        // 3. Ensure no other methods were called on this mock.
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );

    test(
      'should return a Failure when TokenSharedPrefs.clearToken fails',
      () async {
        // ARRANGE: Set up the mock to return a failure.
        when(
          () => mockTokenSharedPrefs.clearToken(),
        ).thenAnswer((_) async => const Left(tFailure));

        // ACT: Execute the use case.
        final result = await usecase();

        // ASSERT: Verify the failure outcome.
        // 1. The result should be a Left containing the failure object.
        expect(result, const Left(tFailure));

        // 2. Verify that clearToken() was still called exactly once.
        verify(() => mockTokenSharedPrefs.clearToken()).called(1);

        // 3. Ensure no other interactions with the mock.
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );
  });
}
