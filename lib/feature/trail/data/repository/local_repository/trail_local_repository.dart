import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/data_source/local_data_source/trail_local_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/repository/trail_repository.dart';

class TrailLocalRepository implements ITrailRepository {
  final TrailLocalDataSource trailLocalDataSource;

  TrailLocalRepository({required this.trailLocalDataSource});

  @override
  Future<Either<Failure, List<TrailEnitiy>>> getTrails() async {
    try {
      final trails = await trailLocalDataSource.getTrails();
      return Right(trails);
    } catch (e) {
      return Left(
        LocalDataBaseFailure(message: 'Failed to get trails: ${e.toString()}'),
      );
    }
  }
}
