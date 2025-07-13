import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/model/sender_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

part 'message_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageApiModel {
  @JsonKey(name: '_id')
  final String messageId;

  final String text;

  final SenderApiModel sender;

  @JsonKey(name: "group")
  final String groupId;

  final DateTime timestamp;

  MessageApiModel({
    required this.messageId,
    required this.text,
    required this.sender,
    required this.groupId,
    required this.timestamp,
  });

  factory MessageApiModel.fromJson(Map<String, dynamic> json) =>
      _$MessageApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageApiModelToJson(this);

  MessageEntity toEntity() {
    return MessageEntity(
      messageId: messageId,
      text: text,
      sender: sender.toEntity(),
      groupId: groupId,
      senderId: sender.senderId,
      timestamp: timestamp,
    );
  }

  static List<MessageEntity> toEntityList(List<MessageApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
