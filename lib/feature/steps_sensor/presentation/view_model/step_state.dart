import 'package:equatable/equatable.dart';

import '../enum_step_status.dart';

class StepState extends Equatable {
  final StepStatus status;
  final int sessionSteps;
  final int totalSteps;
  final String errorMessage;

  const StepState({
    required this.status,
    required this.sessionSteps,
    required this.totalSteps,
    required this.errorMessage,
  });

  factory StepState.initial() {
    return const StepState(
      status: StepStatus.idle,
      sessionSteps: 0,
      totalSteps: 0,
      errorMessage: '',
    );
  }

  StepState copyWith({
    StepStatus? status,
    int? sessionSteps,
    int? totalSteps,
    String? errorMessage,
  }) {
    return StepState(
      status: status ?? this.status,
      sessionSteps: sessionSteps ?? this.sessionSteps,
      totalSteps: totalSteps ?? this.totalSteps, // <-- ADDED
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  // Corrected the props implementation
  List<Object?> get props => [status, sessionSteps, totalSteps, errorMessage];
}
