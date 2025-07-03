// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantApiModel _$ParticipantApiModelFromJson(Map<String, dynamic> json) =>
    ParticipantApiModel(
      id: json['_id'] as String?,
      user: json['user'] == null
          ? null
          : UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String?,
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$ParticipantApiModelToJson(
        ParticipantApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user?.toJson(),
      'status': instance.status,
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };
