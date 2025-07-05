import 'package:trailmate_mobile_app_assignment/core/network/local/hive_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/data_source/trail_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/model/trail_hive_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

class TrailLocalDataSource implements ITrailDataSource {
  final HiveService hiveService;

  TrailLocalDataSource({required this.hiveService});

  @override
  Future<List<TrailEnitiy>> getTrails() async {
    try {
      final trailModels = await hiveService.getTrail();
      final nonNullableModels =
          trailModels.whereType<TrailHiveModel>().toList();
      return TrailHiveModel.toEntityList(nonNullableModels);
    } catch (e) {
      throw Exception('Failed to get trail : $e');
    }
  }
}
