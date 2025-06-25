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
      duration: (json['duration'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      difficulty: json['difficulty'] as String,
      images: json['images'] as String,
    );

Map<String, dynamic> _$TrailApiModelToJson(TrailApiModel instance) =>
    <String, dynamic>{
      '_id': instance.trailId,
      'name': instance.name,
      'location': instance.location,
      'duration': instance.duration,
      'elevation': instance.elevation,
      'difficulty': instance.difficulty,
      'images': instance.images,
    };
