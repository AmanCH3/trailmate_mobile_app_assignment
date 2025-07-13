import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/sender_entity.dart';

class MessageEntity extends Equatable {
  final String messageId;

  final String text;

  final String senderId;

  final String groupId;

  final SenderEntity sender;

  final DateTime timestamp;

  const MessageEntity({
    required this.messageId,
    required this.text,
    required this.senderId,
    required this.groupId,
    required this.sender,
    required this.timestamp,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    messageId,
    text,
    senderId,
    groupId,
    sender,
    timestamp,
  ];
}
