import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

import '../../../trail/domain/entity/trail_entity.dart';

class StepEntity extends Equatable {
  final String? stepId;
  final UserEntity? user;
  final int? step;
  final DateTime? timeStamps;
  final TrailEnitiy? trail;

  const StepEntity({
    this.stepId,
    this.user,
    this.step,
    this.timeStamps,
    this.trail,
  });

  @override
  List<Object?> get props => [stepId, user, step, timeStamps, trail];
}
