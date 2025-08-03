// Assuming you have a file like this
import 'package:equatable/equatable.dart';

abstract class StepEvent extends Equatable {
  const StepEvent();

  @override
  List<Object?> get props => [];
}

// CHANGE: Removed token parameter
class LoadTotalSteps extends StepEvent {}

// CHANGE: Removed token parameter. The userId should be retrieved
// from an authentication BLoC or service.
class StartStepTracking extends StepEvent {
  final String trailId;

  const StartStepTracking({required this.trailId});

  @override
  List<Object?> get props => [trailId];
}

class StopStepTracking extends StepEvent {}

class PedometerUpdated extends StepEvent {
  final int newStepCount;

  const PedometerUpdated(this.newStepCount);

  @override
  List<Object?> get props => [newStepCount];
}
