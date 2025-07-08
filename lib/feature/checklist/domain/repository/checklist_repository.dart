import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';

abstract interface class ICheckListRepository {
  Future<Either<Failure, Map<String, List<CheckListEntity>>>>
  generateCheckList({
    required String experience,
    required String duration,
    required String weather,
  });
}
