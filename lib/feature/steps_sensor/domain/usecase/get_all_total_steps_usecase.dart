// lib/feature/steps_sensor/domain/usecase/get_all_total_steps_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/repository/step_repository.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

class GetAllTotalStepsUsecase implements UseCaseWithoutParams<int> {
  final StepRepository stepRepository;

  GetAllTotalStepsUsecase({required this.stepRepository});

  @override
  Future<Either<Failure, int>> call() {
    return stepRepository.getTotalSteps();
  }
}
