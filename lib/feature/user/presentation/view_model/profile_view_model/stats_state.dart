import 'package:equatable/equatable.dart';

enum StatsStatus { initial, initializing, tracking, saving, success, failure }

class StatsState extends Equatable {
  final StatsStatus status;
  final int sessionSteps;
  final String? errorMessage;
  final bool isPedometerAvailable;

  const StatsState({
    required this.status,
    required this.sessionSteps,
    this.errorMessage,
    required this.isPedometerAvailable,
  });

  factory StatsState.initial() {
    return const StatsState(
      status: StatsStatus.initial,
      sessionSteps: 0,
      errorMessage: null,
      isPedometerAvailable: false,
    );
  }

  StatsState copyWith({
    StatsStatus? status,
    int? sessionSteps,
    String? errorMessage,
    bool? isPedometerAvailable,
  }) {
    return StatsState(
      status: status ?? this.status,
      sessionSteps: sessionSteps ?? this.sessionSteps,
      errorMessage: errorMessage ?? this.errorMessage,
      isPedometerAvailable: isPedometerAvailable ?? this.isPedometerAvailable,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sessionSteps,
    errorMessage,
    isPedometerAvailable,
  ];
}
