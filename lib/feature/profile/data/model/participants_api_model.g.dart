// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantApiModel _$ParticipantApiModelFromJson(Map<String, dynamic> json) =>
    ParticipantApiModel(
      participantId: json['_id'] as String,
      user: UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String,
    );

Map<String, dynamic> _$ParticipantApiModelToJson(
        ParticipantApiModel instance) =>
    <String, dynamic>{
      '_id': instance.participantId,
      'user': instance.user.toJson(),
      'status': instance.status,
    };
