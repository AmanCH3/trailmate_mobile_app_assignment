// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_trail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllTrailDto _$GetAllTrailDtoFromJson(Map<String, dynamic> json) =>
    GetAllTrailDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => TrailApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllTrailDtoToJson(GetAllTrailDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
