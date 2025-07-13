import 'package:equatable/equatable.dart';

import '../../domain/entity/message_entity.dart';

abstract class ChatState extends Equatable {
  final List<MessageEntity> messages;

  const ChatState({this.messages = const []});

  @override
  List<Object> get props => [messages];
}

/// The initial state before any action is taken.
class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  const ChatSuccess({required List<MessageEntity> messages})
    : super(messages: messages);
}

/// The state when an error occurs.
class ChatFailure extends ChatState {
  final String error;

  const ChatFailure({
    required this.error,
    required List<MessageEntity> messages,
  }) : super(messages: messages);

  @override
  List<Object> get props => [error, messages];
}
