import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

abstract interface class ITrailDataSource {
  Future<List<TrailEnitiy>> getTrails();
}
