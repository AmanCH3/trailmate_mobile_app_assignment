// FILE: lib/feature/grouplist/presentation/view_model/chat_event.dart

import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the chat screen is first loaded.
class InitializeChat extends ChatEvent {
  final String groupId;
  final String currentUserId;

  const InitializeChat({required this.groupId, required this.currentUserId});

  @override
  List<Object> get props => [groupId, currentUserId];
}

/// Event triggered when the user sends a new message.
class SendMessage extends ChatEvent {
  final String groupId;
  final String senderId;
  final String content;

  const SendMessage({
    required this.groupId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object> get props => [groupId, senderId, content];
}

/// Event triggered internally when a new message is received from the socket.
class NewMessageReceived extends ChatEvent {
  final MessageEntity message;

  const NewMessageReceived({required this.message});

  @override
  List<Object> get props => [message];
}
