// FILE: chat_state.dart

import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

enum ConnectionStatus { disconnected, connecting, connected, failed }

abstract class ChatState extends Equatable {
  final List<MessageEntity> messages;
  final ConnectionStatus connectionStatus;

  const ChatState({required this.messages, required this.connectionStatus});

  @override
  List<Object> get props => [messages, connectionStatus];
}

class ChatInitial extends ChatState {
  ChatInitial()
    : super(messages: [], connectionStatus: ConnectionStatus.disconnected);
}

// Add connectionStatus to all your states
class ChatLoading extends ChatState {
  const ChatLoading({required super.messages, required super.connectionStatus});
}

class ChatSuccess extends ChatState {
  const ChatSuccess({required super.messages})
    : super(connectionStatus: ConnectionStatus.connected);
}

class ChatFailure extends ChatState {
  final String error;

  const ChatFailure({required this.error, required super.messages})
    : super(connectionStatus: ConnectionStatus.failed);

  @override
  List<Object> get props => [messages, connectionStatus, error];
}
