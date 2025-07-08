import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/repository/checklist_repository.dart';

import '../../data_source/remote_data_source/checklist_remote_data_source.dart';

class ChecklistRepositoryImpl implements ICheckListRepository {
  final ChecklistRemoteDataSource remoteDataSource;

  ChecklistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, List<CheckListEntity>>>>
  generateCheckList({
    required String experience,
    required String duration,
    required String weather,
  }) async {
    try {
      // 1. Get the raw Models from the data source
      final remoteChecklistModel = await remoteDataSource.generateCheckList(
        experience: experience,
        duration: duration,
        weather: weather,
      );

      // 2. Convert the Map of Model lists to a Map of Entity lists
      final Map<String, List<CheckListEntity>> entityMap = remoteChecklistModel
          .map((category, modelList) {
            return MapEntry(
              category,
              modelList.map((model) => model.toEntity()).toList(),
            );
          });

      // 3. Return the successful result wrapped in Right
      return Right(entityMap);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: null));
    } on Exception catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }
}
