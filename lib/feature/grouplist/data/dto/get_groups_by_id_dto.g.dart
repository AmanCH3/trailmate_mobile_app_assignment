// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_groups_by_id_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGroupsByIdDto _$GetGroupsByIdDtoFromJson(Map<String, dynamic> json) =>
    GetGroupsByIdDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: GroupApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetGroupsByIdDtoToJson(GetGroupsByIdDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
