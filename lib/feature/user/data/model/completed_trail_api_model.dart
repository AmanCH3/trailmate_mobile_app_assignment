import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/completed_trail_entity.dart';

part 'completed_trail_api_model.g.dart';

@JsonSerializable()
class CompletedTrailApiModel extends Equatable {
  final String trail;
  final DateTime completedAt;

  const CompletedTrailApiModel({
    required this.trail,
    required this.completedAt,
  });

  factory CompletedTrailApiModel.fromJson(Map<String, dynamic> json) =>
      _$CompletedTrailApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedTrailApiModelToJson(this);

  CompletedTrailEntity toEntity() {
    return CompletedTrailEntity(trailId: trail, completedAt: completedAt);
  }

  factory CompletedTrailApiModel.fromEntity(CompletedTrailEntity entity) {
    return CompletedTrailApiModel(
      trail: entity.trailId,
      completedAt: entity.completedAt,
    );
  }

  @override
  List<Object?> get props => [trail, completedAt];
}
