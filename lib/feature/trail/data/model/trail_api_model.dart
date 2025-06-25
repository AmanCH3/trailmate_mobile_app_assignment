import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

part 'trail_api_model.g.dart';

@JsonSerializable()
class TrailApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String? trailId;
  final String name;
  final String location;
  final double duration;
  final double elevation;
  final String difficulty;
  final String images;

  TrailApiModel({
    this.trailId,
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

  //To entity
  TrailEnitiy toEntity() {
    return TrailEnitiy(
      trailId: trailId,
      name: name,
      location: location,
      duration: duration,
      elevation: elevation,
      difficulty: difficulty,
      images: images,
    );
  }

  // From entity
  factory TrailApiModel.fromEntity(TrailEnitiy entity) {
    final trail = TrailApiModel(
      name: entity.name,
      location: entity.location,
      duration: entity.duration,
      elevation: entity.elevation,
      difficulty: entity.difficulty,
      images: entity.images,
    );
    return trail;
  }

  @override
  // TODO: implement props
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
