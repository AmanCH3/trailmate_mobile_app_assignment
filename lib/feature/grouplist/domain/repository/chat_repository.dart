import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

abstract interface class IChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessageHistory(
    String groupId,
  );

  Future<Either<Failure, void>> sendMessage({
    required String text,
    required String groupId,
    required String senderId,
  });

  Either<Failure, Stream<MessageEntity>> listenForNewMessage();

  void joinGroup(String groupId);

  Future<Either<Failure, void>> disconnect();
}
