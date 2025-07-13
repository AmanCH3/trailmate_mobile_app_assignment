import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/data_source/remote_data_source/chat_remote_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

import '../../../domain/repository/chat_repository.dart';
import '../../model/message_api_model.dart';

class ChatRemoteRepository implements IChatRepository {
  final ChatRemoteDataSourceImpl chatRemoteDataSourceImpl;

  ChatRemoteRepository({required this.chatRemoteDataSourceImpl});

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessageHistory(
    String groupId,
  ) async {
    try {
      final List<MessageApiModel> messageModels = await chatRemoteDataSourceImpl
          .getMessageHistory(groupId);
      final List<MessageEntity> messageEntities = MessageApiModel.toEntityList(
        messageModels,
      );
      return Right(messageEntities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  void joinGroup(String groupId) {
    chatRemoteDataSourceImpl.connectAndListen(groupId);
  }

  @override
  Either<Failure, Stream<MessageEntity>> listenForNewMessage() {
    try {
      final streamOfModels = chatRemoteDataSourceImpl.newMessageStream;
      final streamOfEntities = streamOfModels.map((model) => model.toEntity());
      return Right(streamOfEntities);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to listen for message $e', statusCode: 500),
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
        'groudId': groupId,
        'senderId': senderId,
      };

      await chatRemoteDataSourceImpl.sendMessage(messageData);
      return const Right(null); // Success
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      chatRemoteDataSourceImpl.dispose();
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }
}
