import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/usecase/save_step_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_view_model.dart';

class MockSaveSteps extends Mock implements SaveSteps {}

class MockUserGetUseCase extends Mock implements UserGetUseCase {}

class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

class MockUserEntity extends Mock implements UserEntity {}

class MockPermission extends Mock implements Permission {}

class MockStepCount extends Mock implements StepCount {}

void main() {
  late StatsViewModel statsViewModel;
  late MockSaveSteps mockSaveSteps;
  late MockUserGetUseCase mockUserGetUseCase;
  late MockUserEntity mockUserEntity;

  setUpAll(() {
    registerFallbackValue(StepEntity(step: 0, timeStamps: DateTime.now()));
  });

  setUp(() {
    mockSaveSteps = MockSaveSteps();
    mockUserGetUseCase = MockUserGetUseCase();
    mockUserEntity = MockUserEntity();

    when(
      () => mockUserGetUseCase(),
    ).thenAnswer((_) async => Right(mockUserEntity));

    statsViewModel = StatsViewModel(
      saveStepsUseCase: mockSaveSteps,
      userGetUseCase: mockUserGetUseCase,
    );
  });

  tearDown(() {
    statsViewModel.close();
  });

  group('StatsViewModel', () {
    test('initial state is correct', () {
      expect(statsViewModel.state, StatsState.initial());
    });

    test('loads current user on initialization', () async {
      verify(() => mockUserGetUseCase()).called(1);
    });
    group('StopHikeTracking', () {
      blocTest<StatsViewModel, StatsState>(
        'emits [saving, failure] when save fails',
        build: () {
          final failure = MockFailure('DB error');
          when(
            () => mockSaveSteps(any()),
          ).thenAnswer((_) async => Left(failure));
          return statsViewModel;
        },
        seed:
            () => StatsState.initial().copyWith(
              status: StatsStatus.tracking,
              sessionSteps: 123,
            ),
        act: (bloc) => bloc.add(StopHikeTracking()),
        expect:
            () => [
              StatsState.initial().copyWith(
                status: StatsStatus.saving,
                sessionSteps: 123,
              ),
              StatsState.initial().copyWith(
                status: StatsStatus.failure,
                sessionSteps: 123,
                errorMessage: 'Failed to save hike data: DB error',
              ),
            ],
      );

      blocTest<StatsViewModel, StatsState>(
        'emits [initial] and does not save if no steps were taken',
        build: () => statsViewModel,
        seed:
            () => StatsState.initial().copyWith(
              status: StatsStatus.tracking,
              sessionSteps: 0,
            ),
        act: (bloc) => bloc.add(StopHikeTracking()),
        expect:
            () => [
              StatsState.initial().copyWith(
                status: StatsStatus.initial,
                sessionSteps: 0,
              ),
            ],
        verify: (_) {
          verifyNever(() => mockSaveSteps(any()));
        },
      );
    });
  });
}
