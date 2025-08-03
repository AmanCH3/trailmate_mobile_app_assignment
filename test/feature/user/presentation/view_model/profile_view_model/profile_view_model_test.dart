import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_delete_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_update_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';

// --- Mocks for Dependencies ---
class MockUserGetUseCase extends Mock implements UserGetUseCase {}

class MockUserUpdateUsecase extends Mock implements UserUpdateUsecase {}

class MockUserDeleteUsecase extends Mock implements UserDeleteUsecase {}

// Mock for the data entity
class MockUserEntity extends Mock implements UserEntity {}

// Mock for the Failure class
class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

void main() {
  late ProfileViewModel profileViewModel;
  late MockUserGetUseCase mockUserGetUseCase;
  late MockUserUpdateUsecase mockUserUpdateUsecase;
  late MockUserDeleteUsecase mockUserDeleteUsecase;

  // Test data
  final tUser = MockUserEntity();
  final tUpdatedUser = MockUserEntity();
  final tFailure = MockFailure('Something went wrong');

  setUpAll(() {
    // Register fallback values for custom objects passed to mocked methods.
    // This is required for the `UpdateProfileEvent`.
    registerFallbackValue(MockUserEntity());
  });

  setUp(() {
    mockUserGetUseCase = MockUserGetUseCase();
    mockUserUpdateUsecase = MockUserUpdateUsecase();
    mockUserDeleteUsecase = MockUserDeleteUsecase();
  });

  group('ProfileViewModel', () {
    // Test the constructor behavior separately because it triggers an event.
    test('initial state is ProfileState.initial()', () {
      // Stub the use case before creating the BLoC
      when(() => mockUserGetUseCase()).thenAnswer((_) async => Right(tUser));

      final bloc = ProfileViewModel(
        userGetUseCase: mockUserGetUseCase,
        userUpdateUseCase: mockUserUpdateUsecase,
        userDeleteUsecase: mockUserDeleteUsecase,
      );

      expect(bloc.state, ProfileState.initial());
    });

    // Group tests by event
    group('LoadProfileEvent', () {
      blocTest<ProfileViewModel, ProfileState>(
        'emits [loading, success] when UserGetUseCase succeeds',
        setUp: () {
          when(
            () => mockUserGetUseCase(),
          ).thenAnswer((_) async => Right(tUser));
        },
        build:
            () => ProfileViewModel(
              userGetUseCase: mockUserGetUseCase,
              userUpdateUseCase: mockUserUpdateUsecase,
              userDeleteUsecase: mockUserDeleteUsecase,
            ),
        // The event is added by the constructor, no need for an `act` block here.
        expect:
            () => [
              ProfileState.initial().copyWith(isLoading: true),
              ProfileState.initial().copyWith(
                isLoading: false,
                userEntity: tUser,
              ),
            ],
      );

      blocTest<ProfileViewModel, ProfileState>(
        'emits [loading, failure] when UserGetUseCase fails',
        setUp: () {
          when(
            () => mockUserGetUseCase(),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build:
            () => ProfileViewModel(
              userGetUseCase: mockUserGetUseCase,
              userUpdateUseCase: mockUserUpdateUsecase,
              userDeleteUsecase: mockUserDeleteUsecase,
            ),
        expect:
            () => [
              ProfileState.initial().copyWith(isLoading: true),
              ProfileState.initial().copyWith(
                isLoading: false,
                onError: tFailure.message,
              ),
            ],
      );
    });
  });
}
