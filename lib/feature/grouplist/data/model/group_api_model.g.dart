// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupApiModel _$GroupApiModelFromJson(Map<String, dynamic> json) =>
    GroupApiModel(
      groupId: json['_id'] as String,
      title: json['title'] as String,
      trail: json['trail'] == null
          ? null
          : TrailApiModel.fromJson(json['trail'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      maxSize: (json['maxSize'] as num?)?.toInt(),
      leader: json['leader'] == null
          ? null
          : UserApiModel.fromJson(json['leader'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ParticipantApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      meetingPoint: json['meetingPoint'] as Map<String, dynamic>?,
      requirements: (json['requirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      difficulty: json['difficulty'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupApiModelToJson(GroupApiModel instance) =>
    <String, dynamic>{
      '_id': instance.groupId,
      'title': instance.title,
      'trail': instance.trail?.toJson(),
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'maxSize': instance.maxSize,
      'leader': instance.leader?.toJson(),
      'participants': instance.participants?.map((e) => e.toJson()).toList(),
      'status': instance.status,
      'meetingPoint': instance.meetingPoint,
      'requirements': instance.requirements,
      'difficulty': instance.difficulty,
      'photos': instance.photos,
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
    };
