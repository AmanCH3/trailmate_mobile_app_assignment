// lib/feature/steps_sensor/data/repository/step_remote_repository.dart
import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/data/data_source/step_remote_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/repository/step_repository.dart';

class StepRemoteRepository implements StepRepository {
  final StepRemoteDataSource _stepRemoteDataSource;

  StepRemoteRepository({required StepRemoteDataSource stepRemoteDataSource})
    : _stepRemoteDataSource = stepRemoteDataSource;

  @override
  Future<Either<Failure, int>> getTotalSteps() async {
    try {
      final steps = await _stepRemoteDataSource.getTotalSteps();
      return Right(steps);
    } on ApiFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'An unexpected repository error occurred: $e',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveSteps(StepEntity entity) async {
    try {
      // The data source handles everything. This repository just manages the result.
      await _stepRemoteDataSource.saveSteps(entity);
      return const Right(
        null,
      ); // Return Right(null) for a successful void Future
    } on ApiFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'An unexpected repository error occurred: $e',
          statusCode: 500,
        ),
      );
    }
  }
}
