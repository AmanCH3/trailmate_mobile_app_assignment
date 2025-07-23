import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';

abstract interface class StepRepository {
  Future<Either<Failure, void>> saveSteps(StepEntity entity);

  Future<Either<Failure, int>> getTotalSteps();
}
