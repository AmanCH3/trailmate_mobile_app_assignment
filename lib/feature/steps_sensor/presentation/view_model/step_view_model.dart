import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';

import '../../../../core/service/pedometer_service.dart';
import '../../../user/domain/usecase/user_get_usecase.dart';
import '../../domain/entity/step_entity.dart';
import '../../domain/usecase/get_all_total_steps_usecase.dart';
import '../../domain/usecase/save_step_usecase.dart';
import '../enum_step_status.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  final GetAllTotalStepsUsecase _getAllTotalStepsUsecase;
  final SaveSteps _saveStepsUseCase;
  final PedometerService _pedometerService;
  final UserGetUseCase _userGetUseCase;
  final GetAllTrailUseCase _getAllTrailUseCase;

  StreamSubscription<int>? _pedometerSubscription;
  String? currentUserId;
  String? currentTrailId;

  StepBloc({
    required GetAllTotalStepsUsecase getAllTotalStepsUsecase,
    required SaveSteps saveStepsUseCase,
    required PedometerService pedometerService,
    required UserGetUseCase userGetUseCase,
    required GetAllTrailUseCase getAllTrailUseCase,
  }) : _getAllTotalStepsUsecase = getAllTotalStepsUsecase,
       _saveStepsUseCase = saveStepsUseCase,
       _pedometerService = pedometerService,
       _userGetUseCase = userGetUseCase,
       _getAllTrailUseCase = getAllTrailUseCase,
       super(StepState.initial()) {
    on<LoadTotalSteps>(_onLoadTotalSteps);
    on<StartStepTracking>(_onStartStepTracking);
    on<StopStepTracking>(_onStopStepTracking);
    on<PedometerUpdated>(_onPedometerUpdated);

    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userResult = await _userGetUseCase();
    userResult.fold(
      (failure) {
        currentUserId = null;
      },
      (user) {
        currentUserId = user.userId;
      },
    );
  }

  Future<void> _onLoadTotalSteps(
    LoadTotalSteps event,
    Emitter<StepState> emit,
  ) async {
    emit(state.copyWith(status: StepStatus.loading));
    final result = await _getAllTotalStepsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: StepStatus.error, errorMessage: failure.message),
      ),
      (totalSteps) => emit(
        state.copyWith(status: StepStatus.success, totalSteps: totalSteps),
      ),
    );
  }

  void _onStartStepTracking(StartStepTracking event, Emitter<StepState> emit) {
    if (state.status == StepStatus.tracking) return; // Prevent multiple starts

    currentTrailId = event.trailId;

    emit(state.copyWith(status: StepStatus.tracking, sessionSteps: 0));

    _pedometerService.start();

    _pedometerSubscription = _pedometerService.sessionStepsStream.listen(
      (int stepsThisSession) {
        add(PedometerUpdated(stepsThisSession));
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: StepStatus.error,
            errorMessage: 'Pedometer sensor is not available.',
          ),
        );
        add(StopStepTracking());
      },
      cancelOnError: true,
    );
  }

  void _onPedometerUpdated(PedometerUpdated event, Emitter<StepState> emit) {
    emit(state.copyWith(sessionSteps: event.newStepCount));
  }

  Future<void> _onStopStepTracking(
    StopStepTracking event,
    Emitter<StepState> emit,
  ) async {
    await _pedometerSubscription?.cancel();
    _pedometerSubscription = null;
    _pedometerService.stop();

    final userId = currentUserId.toString();

    if (state.sessionSteps > 0 && userId != null && currentTrailId != null) {
      emit(state.copyWith(status: StepStatus.saving));

      // CHANGE: Create a much simpler entity. The backend only needs the IDs.
      // Your backend gets the userId from the token, but sending it in the body is also fine.
      final stepEntityToSave = StepEntity();

      final result = await _saveStepsUseCase(stepEntityToSave);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: StepStatus.error,
              errorMessage: 'Failed to save steps: ${failure.message}',
            ),
          );
        },
        (success) {
          final newTotal = state.totalSteps + state.sessionSteps;
          emit(
            state.copyWith(
              // Change status to reflect completion, e.g., 'loaded'
              status: StepStatus.success,
              sessionSteps: 0,
              totalSteps: newTotal,
            ),
          );
        },
      );
    } else {
      // Reset to a non-tracking state, e.g., loaded
      emit(state.copyWith(status: StepStatus.success, sessionSteps: 0));
    }

    currentTrailId = null;
  }

  @override
  Future<void> close() {
    _pedometerSubscription?.cancel();
    _pedometerService.dispose();
    return super.close();
  }
}
