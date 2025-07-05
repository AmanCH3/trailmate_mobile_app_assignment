import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/stats_entity.dart';

part 'stats_api_model.g.dart';

@JsonSerializable()
class StatsApiModel extends Equatable {
  final int totalHikes;
  final double totalDistance;
  final double totalElevation;
  final double totalHours;
  final int hikesJoined;
  final int hikesLed;

  const StatsApiModel({
    this.totalHikes = 0,
    this.totalDistance = 0.0,
    this.totalElevation = 0.0,
    this.totalHours = 0.0,
    this.hikesJoined = 0,
    this.hikesLed = 0,
  });

  factory StatsApiModel.fromJson(Map<String, dynamic> json) =>
      _$StatsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatsApiModelToJson(this);

  StatsEntity toEntity() {
    return StatsEntity(
      totalHikes: totalHikes,
      totalDistance: totalDistance,
      totalElevation: totalElevation,
      totalHours: totalHours,
      hikesJoined: hikesJoined,
      hikesLed: hikesLed,
    );
  }

  factory StatsApiModel.fromEntity(StatsEntity entity) {
    return StatsApiModel(
      totalHikes: entity.totalHikes,
      totalDistance: entity.totalDistance,
      totalElevation: entity.totalElevation,
      totalHours: entity.totalHours,
      hikesJoined: entity.hikesJoined,
      hikesLed: entity.hikesLed,
    );
  }

  @override
  List<Object?> get props => [
    totalHikes,
    totalDistance,
    totalElevation,
    totalHours,
    hikesJoined,
    hikesLed,
  ];
}
