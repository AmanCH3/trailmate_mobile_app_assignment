import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/sender_entity.dart';

class MessageEntity extends Equatable {
  final String? messageId;

  final String? text;

  final String? senderId;

  final String? groupId;

  final SenderEntity? sender;

  const MessageEntity({
    this.messageId,
    this.text,
    this.senderId,
    this.groupId,
    this.sender,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [messageId, text, senderId, groupId, sender];
}
