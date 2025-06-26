import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

abstract interface class ITrailRepository {
  Future<Either<Failure, List<TrailEnitiy>>> getTrails();
}
