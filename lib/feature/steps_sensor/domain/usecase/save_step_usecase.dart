import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/repository/step_repository.dart';

class SaveSteps implements UseCaseWithParams<void, StepEntity> {
  final StepRepository repository;

  SaveSteps(this.repository);

  @override
  Future<Either<Failure, void>> call(StepEntity params) async {
    return await repository.saveSteps(params);
  }
}
