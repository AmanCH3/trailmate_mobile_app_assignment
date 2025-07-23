import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

part 'trail_api_model.g.dart';

@JsonSerializable()
class DurationApiModel {
  final int min;
  final int max;

  DurationApiModel({required this.min, required this.max});

  factory DurationApiModel.fromJson(Map<String, dynamic> json) =>
      _$DurationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DurationApiModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TrailApiModel {
  @JsonKey(name: '_id')
  final String trailId;
  final String name;
  final String location;
  final double elevation;
  final DurationApiModel duration;
  final double? distance;
  @JsonKey(name: 'difficult')
  final String difficulty;

  final List<String>? images;

  TrailApiModel({
    required this.trailId,
    required this.name,
    required this.location,
    this.distance,
    required this.duration,
    required this.elevation,
    required this.difficulty,

    this.images,
  });

  factory TrailApiModel.fromJson(Map<String, dynamic> json) =>
      _$TrailApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrailApiModelToJson(this);

  TrailEnitiy toEntity() {
    return TrailEnitiy(
      trailId: trailId,
      name: name,
      location: location,
      duration: duration.max.toDouble(),
      elevation: elevation,
      difficulty: difficulty,
      images: images?.isNotEmpty == true ? images!.first : '',
      distance: distance,
    );
  }

  static List<TrailEnitiy> toEntityList(List<TrailApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
