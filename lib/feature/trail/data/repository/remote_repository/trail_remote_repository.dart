import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/data_source/remote_data_source/trail_remote_datasource.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/repository/trail_repository.dart';

class TrailRemoteRepository implements ITrailRepository {
  final TrailRemoteDataSource trailRemoteDataSource;

  TrailRemoteRepository({required this.trailRemoteDataSource});

  @override
  Future<Either<Failure, List<TrailEnitiy>>> getTrails() async {
    try {
      final trail = await trailRemoteDataSource.getTrails();
      return Right(trail);
    } catch (e) {
      return Left(ApiFailure(statusCode: null, message: e.toString()));
    }
  }
}
