// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepApiModel _$StepApiModelFromJson(Map<String, dynamic> json) => StepApiModel(
      stepId: json['_id'] as String,
      user: UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
      trail: TrailApiModel.fromJson(json['trail'] as Map<String, dynamic>),
      step: (json['step'] as num).toInt(),
      timeStamps: DateTime.parse(json['timeStamps'] as String),
    );

Map<String, dynamic> _$StepApiModelToJson(StepApiModel instance) =>
    <String, dynamic>{
      '_id': instance.stepId,
      'user': instance.user.toJson(),
      'trail': instance.trail.toJson(),
      'step': instance.step,
      'timeStamps': instance.timeStamps.toIso8601String(),
    };
