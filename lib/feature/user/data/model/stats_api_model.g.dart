// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsApiModel _$StatsApiModelFromJson(Map<String, dynamic> json) =>
    StatsApiModel(
      totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 0,
      totalHikes: (json['totalHikes'] as num?)?.toInt() ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      totalElevation: (json['totalElevation'] as num?)?.toDouble() ?? 0.0,
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0.0,
      hikesJoined: (json['hikesJoined'] as num?)?.toInt() ?? 0,
      hikesLed: (json['hikesLed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StatsApiModelToJson(StatsApiModel instance) =>
    <String, dynamic>{
      'totalSteps': instance.totalSteps,
      'totalHikes': instance.totalHikes,
      'totalDistance': instance.totalDistance,
      'totalElevation': instance.totalElevation,
      'totalHours': instance.totalHours,
      'hikesJoined': instance.hikesJoined,
      'hikesLed': instance.hikesLed,
    };
