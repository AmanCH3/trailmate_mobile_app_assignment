// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckListApiModel _$CheckListApiModelFromJson(Map<String, dynamic> json) =>
    CheckListApiModel(
      id: (json['id'] as num).toInt(),
      name: json['text'] as String,
      checked: json['checked'] as bool,
    );

Map<String, dynamic> _$CheckListApiModelToJson(CheckListApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.name,
      'checked': instance.checked,
    };
