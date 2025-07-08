import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';

class ListenForNewMessageUseCase
    implements UseCaseWithoutParams<Stream<MessageEntity>> {
  final IChatRepository chatRepository;

  ListenForNewMessageUseCase(this.chatRepository);

  @override
  Future<Either<Failure, Stream<MessageEntity>>> call() async {
    // Note: The repository method is synchronous because it just returns a stream handle.
    return chatRepository.listenForNewMessage();
  }
}
