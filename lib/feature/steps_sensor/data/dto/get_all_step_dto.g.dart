// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_step_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllStepDto _$GetAllStepDtoFromJson(Map<String, dynamic> json) =>
    GetAllStepDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => StepApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllStepDtoToJson(GetAllStepDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
