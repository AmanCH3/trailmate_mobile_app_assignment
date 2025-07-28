import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/usecase/save_step_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_state.dart';

class StatsViewModel extends Bloc<StatsEvent, StatsState> {
  final SaveSteps _saveStepsUseCase;
  final UserGetUseCase _userGetUseCase;
  StreamSubscription<StepCount>? _pedometerSubscription;
  StreamSubscription<int>? _sessionStepsSubscription;
  final StreamController<int> _sessionStepsController = StreamController<int>.broadcast();
  int _initialSteps = 0;
  String? _currentUserId;

  StatsViewModel({
    required SaveSteps saveStepsUseCase,
    required UserGetUseCase userGetUseCase,
  }) : _saveStepsUseCase = saveStepsUseCase,
       _userGetUseCase = userGetUseCase,
       super(StatsState.initial()) {
    // Add initialization event handler
    on<InitializePedometer>(_onInitializePedometer);
    // We only need to handle the two user-initiated events: starting and stopping.
    on<StartHikeTracking>(_onStartHikeTracking);
    on<StopHikeTracking>(_onStopHikeTracking);

    // Listen to session steps updates
    _sessionStepsSubscription = _sessionStepsController.stream.listen(
      (sessionSteps) {
        if (!isClosed) {
          emit(state.copyWith(sessionSteps: sessionSteps));
        }
      },
    );

    // Load current user
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userResult = await _userGetUseCase();
    userResult.fold(
      (failure) {
        _currentUserId = null;
      },
      (user) {
        _currentUserId = user.userId;
      },
    );
  }

  /// Handles pedometer initialization and availability check
  Future<void> _onInitializePedometer(
    InitializePedometer event,
    Emitter<StatsState> emit,
  ) async {
    // Set status to initializing
    emit(state.copyWith(status: StatsStatus.initializing));

    try {
      // First, request activity recognition permission
      final status = await Permission.activityRecognition.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        emit(
          state.copyWith(
            status: StatsStatus.failure,
            isPedometerAvailable: false,
            errorMessage:
                'Activity recognition permission is required for step counting.',
          ),
        );
        return;
      }

      // Test if pedometer is available by trying to get the first step count
      await Pedometer.stepCountStream.first;
      emit(
        state.copyWith(status: StatsStatus.initial, isPedometerAvailable: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StatsStatus.failure,
          isPedometerAvailable: false,
          errorMessage: 'Pedometer not available or permission denied.',
        ),
      );
    }
  }

  /// Handles the logic for starting a hike tracking session.
  Future<void> _onStartHikeTracking(
    StartHikeTracking event,
    Emitter<StatsState> emit,
  ) async {
    // Prevent starting a new session if one is already active.
    if (state.status == StatsStatus.tracking) return;

    try {
      // Get the device's total step count *once* to use as a baseline.
      final initialCount = await Pedometer.stepCountStream.first;
      _initialSteps = initialCount.steps;

      // Set the state to tracking and reset the session steps to 0.
      emit(state.copyWith(status: StatsStatus.tracking, sessionSteps: 0));

      // Create a long-lived subscription to the pedometer stream.
      // Use the stream controller to handle updates
      _pedometerSubscription = Pedometer.stepCountStream.listen(
        (StepCount currentStepCount) {
          // Calculate steps taken *during this session* by subtracting the baseline.
          final sessionSteps = currentStepCount.steps - _initialSteps;

          // Add to the stream controller instead of directly emitting
          _sessionStepsController.add(sessionSteps);
        },
        onError: (error) {
          // Handle any errors from the sensor stream.
          if (!isClosed) {
            emit(
              state.copyWith(
                status: StatsStatus.failure,
                errorMessage: "Pedometer sensor error.",
              ),
            );
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      // This catches errors if the sensor is unavailable or permission is denied.
      emit(
        state.copyWith(
          isPedometerAvailable: false,
          errorMessage: 'Pedometer not available or permission denied.',
        ),
      );
    }
  }

  /// Handles the logic for stopping a hike tracking session and saving the data.
  Future<void> _onStopHikeTracking(
    StopHikeTracking event,
    Emitter<StatsState> emit,
  ) async {
    // Always cancel the subscription when stopping to prevent leaks and save battery.
    await _pedometerSubscription?.cancel();
    _pedometerSubscription = null;

    // If we weren't tracking or no steps were taken, just reset to the initial state.
    if (state.sessionSteps <= 0 || state.status != StatsStatus.tracking) {
      emit(state.copyWith(status: StatsStatus.initial, sessionSteps: 0));
      return;
    }

    emit(state.copyWith(status: StatsStatus.saving));

    try {
      // Create a StepEntity for the existing step system
      final stepEntity = StepEntity(
        step: state.sessionSteps,
        timeStamps: DateTime.now(),
      );
      
      final result = await _saveStepsUseCase(stepEntity);

      result.fold(
        (failure) {
          print('Stats update failed: ${failure.message}');
          emit(
            state.copyWith(
              status: StatsStatus.failure,
              errorMessage: 'Failed to save hike data: ${failure.message}',
            ),
          );
        },
        (success) {
          print('Stats updated successfully: ${state.sessionSteps} steps');
          emit(
            state.copyWith(
              status: StatsStatus.success,
              // We keep the step count visible for a moment to show the final result.
            ),
          );
          // After a short delay, reset the BLoC to its initial state for the next hike.
          Future.delayed(const Duration(seconds: 2), () {
            if (!isClosed) {
              emit(StatsState.initial());
            }
          });
        },
      );
    } catch (e) {
      print('Unexpected error during stats update: $e');
      emit(
        state.copyWith(
          status: StatsStatus.failure,
          errorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  /// Ensures the subscription is cancelled if the BLoC is disposed.
  @override
  Future<void> close() {
    _pedometerSubscription?.cancel();
    _sessionStepsSubscription?.cancel();
    _sessionStepsController.close();
    return super.close();
  }
}
