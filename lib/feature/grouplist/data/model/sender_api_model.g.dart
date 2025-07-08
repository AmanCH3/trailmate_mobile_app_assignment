// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SenderApiModel _$SenderApiModelFromJson(Map<String, dynamic> json) =>
    SenderApiModel(
      senderId: json['_id'] as String,
      name: json['name'] as String?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$SenderApiModelToJson(SenderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.senderId,
      'name': instance.name,
      'profileImage': instance.profileImage,
    };
