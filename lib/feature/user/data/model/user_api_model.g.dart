// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      hikerType: json['hikerType'] as String?,
      ageGroup: json['ageGroup'] as String?,
      emergencyContact: json['emergencyContact'] == null
          ? null
          : EmergencyContactApiModel.fromJson(
              json['emergencyContact'] as Map<String, dynamic>),
      bio: json['bio'] as String?,
      profileImage: json['profileImage'] as String?,
      joinDate: json['joinDate'] == null
          ? null
          : DateTime.parse(json['joinDate'] as String),
      role: json['role'] as String?,
      subscription: json['subscription'] as String?,
      active: json['active'] as bool?,
      stats: json['stats'] == null
          ? null
          : StatsApiModel.fromJson(json['stats'] as Map<String, dynamic>),
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      completedTrails: (json['completedTrails'] as List<dynamic>?)
          ?.map(
              (e) => CompletedTrailApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'hikerType': instance.hikerType,
      'ageGroup': instance.ageGroup,
      'emergencyContact': instance.emergencyContact,
      'bio': instance.bio,
      'profileImage': instance.profileImage,
      'joinDate': instance.joinDate?.toIso8601String(),
      'role': instance.role,
      'subscription': instance.subscription,
      'active': instance.active,
      'stats': instance.stats,
      'achievements': instance.achievements,
      'completedTrails': instance.completedTrails,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
