import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';

class ListenForNewMessageUseCase {
  final IChatRepository _repository;

  ListenForNewMessageUseCase(this._repository);

  Either<Failure, Stream<MessageEntity>> call(
    ListenForNewMessageParams params,
  ) {
    return _repository.listenForNewMessage(params.groupId);
  }
}

class ListenForNewMessageParams extends Equatable {
  final String groupId;

  const ListenForNewMessageParams({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
