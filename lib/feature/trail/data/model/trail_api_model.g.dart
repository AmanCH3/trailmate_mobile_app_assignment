// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DurationApiModel _$DurationApiModelFromJson(Map<String, dynamic> json) =>
    DurationApiModel(
      min: (json['min'] as num).toInt(),
      max: (json['max'] as num).toInt(),
    );

Map<String, dynamic> _$DurationApiModelToJson(DurationApiModel instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

TrailApiModel _$TrailApiModelFromJson(Map<String, dynamic> json) =>
    TrailApiModel(
      trailId: json['_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      duration:
          DurationApiModel.fromJson(json['duration'] as Map<String, dynamic>),
      elevation: (json['elevation'] as num).toDouble(),
      difficulty: json['difficult'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TrailApiModelToJson(TrailApiModel instance) =>
    <String, dynamic>{
      '_id': instance.trailId,
      'name': instance.name,
      'location': instance.location,
      'elevation': instance.elevation,
      'duration': instance.duration.toJson(),
      'difficult': instance.difficulty,
      'images': instance.images,
    };
