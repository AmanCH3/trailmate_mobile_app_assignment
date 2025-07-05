import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/repository/trail_repository.dart';

class GetAllTrailUseCase implements UseCaseWithoutParams<List<TrailEnitiy>> {
  final ITrailRepository trailRepository;

  GetAllTrailUseCase({required this.trailRepository});

  @override
  Future<Either<Failure, List<TrailEnitiy>>> call() async {
    return await trailRepository.getTrails();
  }
}
