// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_trail_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedTrailApiModel _$CompletedTrailApiModelFromJson(
        Map<String, dynamic> json) =>
    CompletedTrailApiModel(
      trail: json['trail'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$CompletedTrailApiModelToJson(
        CompletedTrailApiModel instance) =>
    <String, dynamic>{
      'trail': instance.trail,
      'completedAt': instance.completedAt.toIso8601String(),
    };
