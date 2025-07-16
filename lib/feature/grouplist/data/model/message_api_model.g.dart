// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageApiModel _$MessageApiModelFromJson(Map<String, dynamic> json) =>
    MessageApiModel(
      messageId: json['_id'] as String?,
      text: json['text'] as String?,
      sender: json['sender'] == null
          ? null
          : SenderApiModel.fromJson(json['sender'] as Map<String, dynamic>),
      groupId: json['group'] as String?,
      timestamp: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MessageApiModelToJson(MessageApiModel instance) =>
    <String, dynamic>{
      '_id': instance.messageId,
      'text': instance.text,
      'sender': instance.sender?.toJson(),
      'group': instance.groupId,
      'createdAt': instance.timestamp?.toIso8601String(),
    };
