// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_groups_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllGroupsDto _$GetAllGroupsDtoFromJson(Map<String, dynamic> json) =>
    GetAllGroupsDto(
      success: json['success'] as bool,
      pagination: json['pagination'] as Map<String, dynamic>,
      data: (json['data'] as List<dynamic>)
          .map((e) => GroupApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllGroupsDtoToJson(GetAllGroupsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'pagination': instance.pagination,
      'data': instance.data,
    };
