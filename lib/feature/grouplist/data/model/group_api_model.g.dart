// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupApiModel _$GroupApiModelFromJson(Map<String, dynamic> json) =>
    GroupApiModel(
      groupId: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      maxSize: (json['maxSize'] as num).toInt(),
      leader: UserApiModel.fromJson(json['leader'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ParticipantApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      difficulty: json['difficulty'] as String,
    );

Map<String, dynamic> _$GroupApiModelToJson(GroupApiModel instance) =>
    <String, dynamic>{
      '_id': instance.groupId,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'maxSize': instance.maxSize,
      'leader': instance.leader.toJson(),
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'photos': instance.photos,
      'difficulty': instance.difficulty,
    };
