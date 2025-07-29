// Imports for testing
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:equatable/equatable.dart';

// Imports from your project
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/check_auth_status_usecase.dart'; // Adjust path if needed

// --- MOCK CLASS ---
// We only need to mock the dependency of the use case.
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late CheckAuthStatusUseCase usecase;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  setUp(() {
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = CheckAuthStatusUseCase(tokenSharedPrefs: mockTokenSharedPrefs);
  });

  group('CheckAuthStatusUseCase', () {
    const tToken = 'sample_auth_token_from_storage';
    const tFailure = ApiFailure(
      message: 'Failed to read from cache',
      statusCode: null,
    );

    test(
      'should return the token string when a token exists in shared preferences',
      () async {
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));

        final result = await usecase();

        expect(result, const Right(tToken));

        verify(() => mockTokenSharedPrefs.getToken()).called(1);

        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );

    test(
      'should return null when no token exists in shared preferences',
      () async {
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase();

        expect(result, const Right(null));

        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );

    test(
      'should return a Failure when reading from shared preferences fails',
      () async {
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase();

        expect(result, const Left(tFailure));

        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );
  });
}
