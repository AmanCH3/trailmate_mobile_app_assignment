import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
part 'trail_api_model.g.dart';

class TrailApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String? trailId;
  final String name;
  final String location;
  final double durationHours;
  final int elevationMeters;
  final String difficulty;
  final String imageUrl;

  TrailApiModel({
    this.trailId,
    required this.name,
    required this.location,
    required this.durationHours,
    required this.elevationMeters,
    required this.difficulty,
    required this.imageUrl,
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
      durationHours: durationHours,
      elevationMeters: elevationMeters,
      difficulty: difficulty,
      imageUrl: imageUrl,
    );
  }

  // From entity
  factory TrailApiModel.fromEntity(TrailEnitiy entity) {
    final trail = TrailApiModel(
      name: entity.name,
      location: entity.location,
      durationHours: entity.durationHours,
      elevationMeters: entity.elevationMeters,
      difficulty: entity.difficulty,
      imageUrl: entity.imageUrl,
    );
    return trail;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    trailId,
    name,
    location,
    durationHours,
    elevationMeters,
    difficulty,
    imageUrl,
  ];
}
