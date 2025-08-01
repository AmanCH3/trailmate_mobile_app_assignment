import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
// Good practice: Depend on the interface (IChatDataSource), not the implementation.
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/data_source/chat_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart';

class ChatRemoteRepository implements IChatRepository {
  final IChatDataSource chatDataSource;

  ChatRemoteRepository({required this.chatDataSource});

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessageHistory(
    String groupId,
  ) async {
    try {
      final apiMessages = await chatDataSource.getMessageHistory(groupId);
      final domainMessages = apiMessages.map((m) => m.toEntity()).toList();
      return Right(domainMessages);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Either<Failure, Stream<MessageEntity>> listenForNewMessage(String groupId) {
    try {
      chatDataSource.connectAndListen(groupId);
      return Right(chatDataSource.newMessagesStream);
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'Failed to listen for messages: $e',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String text,
    required String groupId,
    required String senderId,
  }) async {
    try {
      final messageData = {
        'text': text,
        'groupId': groupId,
        'senderId': senderId,
      };

      await chatDataSource.sendMessage(messageData);
      return const Right(null); // Success
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      chatDataSource.dispose();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Either<Failure, Stream<ConnectionStatus>> listenForConnectionStatus() {
    try {
      return Right(chatDataSource.connectionStatusStream);
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'Failed to listen for connection status: $e',
          statusCode: 500,
        ),
      );
    }
  }
}
