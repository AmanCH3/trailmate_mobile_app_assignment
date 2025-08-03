import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';

abstract interface class BotRepository {
  Future<Either<Failure, ChatMessageEntity>> getChatReply({
    required String query,
    required List<ChatMessageEntity> history,
    String? token,
  });
}
