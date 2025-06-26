import 'package:hive_flutter/adapters.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
import 'package:uuid/uuid.dart';

part 'trail_hive_model.g.dart';

@HiveType(typeId: 1)
class TrailHiveModel extends HiveObject {
  @HiveField(0)
  final String trailId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final double duration;

  @HiveField(5)
  final double elevation;

  @HiveField(6)
  final String difficulty;

  @HiveField(7)
  final String images;

  TrailHiveModel({
    String? trailId,
    required this.name,
    required this.location,
    required this.duration,
    required this.elevation,
    required this.difficulty,
    required this.images,
  }) : trailId = trailId ?? const Uuid().v4();

  TrailHiveModel.initial()
    : trailId = "",
      name = "",
      location = "",
      duration = 0,
      elevation = 0,
      difficulty = 'moderate',
      images = '';

  TrailEnitiy toEntity() => TrailEnitiy(
    trailId: trailId,
    name: name,
    location: location,
    duration: duration,
    elevation: elevation,
    difficulty: difficulty,
    images: images,
  );

  factory TrailHiveModel.fromEntity(TrailEnitiy entity) => TrailHiveModel(
    trailId: entity.trailId,
    name: entity.name,
    location: entity.location,
    duration: entity.duration,
    elevation: entity.elevation,
    difficulty: entity.difficulty,
    images: entity.images,
  );

  static List<TrailEnitiy> toEntityList(List<TrailHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  List<Object?> get props => [
    trailId,
    name,
    location,
    duration,
    elevation,
    difficulty,
    images,
  ];
}
