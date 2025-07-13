import 'package:equatable/equatable.dart';

import '../../domain/entity/message_entity.dart';

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
  final String text;

  const SendMessage({required this.text});

  @override
  List<Object> get props => [text];
}

class NewMessageReceived extends ChatEvent {
  final MessageEntity message;

  const NewMessageReceived({required this.message});

  @override
  List<Object> get props => [message];
}
