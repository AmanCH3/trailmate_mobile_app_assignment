// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrailApiModel _$TrailApiModelFromJson(Map<String, dynamic> json) =>
    TrailApiModel(
      trailId: json['_id'] as String?,
      name: json['name'] as String,
      location: json['location'] as String,
      durationHours: (json['durationHours'] as num).toDouble(),
      elevationMeters: (json['elevationMeters'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$TrailApiModelToJson(TrailApiModel instance) =>
    <String, dynamic>{
      '_id': instance.trailId,
      'name': instance.name,
      'location': instance.location,
      'durationHours': instance.durationHours,
      'elevationMeters': instance.elevationMeters,
      'difficulty': instance.difficulty,
      'imageUrl': instance.imageUrl,
    };
