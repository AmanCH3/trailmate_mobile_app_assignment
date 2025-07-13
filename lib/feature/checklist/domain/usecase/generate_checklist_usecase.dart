import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/repository/checklist_repository.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

class GenerateChecklistParams extends Equatable {
  final String experience;
  final String duration;
  final String weather;

  const GenerateChecklistParams({
    required this.experience,
    required this.duration,
    required this.weather,
  });

  @override
  List<Object?> get props => [experience, duration, weather];
}

class GenerateChecklistUsecase
    implements
        UseCaseWithParams<
          Map<String, List<CheckListEntity>>,
          GenerateChecklistParams
        > {
  final ICheckListRepository repository;

  GenerateChecklistUsecase(this.repository);

  @override
  Future<Either<Failure, Map<String, List<CheckListEntity>>>> call(
    GenerateChecklistParams params,
  ) async {
    return await repository.generateCheckList(
      experience: params.experience,
      duration: params.duration,
      weather: params.weather,
    );
  }
}
