import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

part 'trail_api_model.g.dart';

// HELPER MODEL: This class perfectly matches the nested "duration" JSON object.
@JsonSerializable()
class DurationApiModel {
  final int min;
  final int max;

  DurationApiModel({required this.min, required this.max});

  factory DurationApiModel.fromJson(Map<String, dynamic> json) =>
      _$DurationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DurationApiModelToJson(this);
}

// CORRECTED MAIN MODEL
@JsonSerializable(
  explicitToJson: true,
) // Added explicitToJson for nested object
class TrailApiModel {
  @JsonKey(name: '_id')
  final String trailId;

  final String name;
  final String location;
  final double elevation;
  final DurationApiModel duration;

  @JsonKey(name: 'difficult')
  final String difficulty;

  // THIS IS THE FIX for images
  final List<String> images;

  TrailApiModel({
    required this.trailId,
    required this.name,
    required this.location,
    required this.duration,
    required this.elevation,
    required this.difficulty,
    required this.images,
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
      images: images.isNotEmpty ? images.first : '', // Fallback for empty list
    );
  }

  static List<TrailEnitiy> toEntityList(List<TrailApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
