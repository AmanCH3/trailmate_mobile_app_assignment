import 'package:equatable/equatable.dart';

abstract class BotEvent extends Equatable {
  const BotEvent();

  @override
  List<Object> get props => [];
}

class SendChatMessage extends BotEvent {
  final String query;

  const SendChatMessage({required this.query});

  @override
  List<Object> get props => [query];
}
