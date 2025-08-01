import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/repository/bot_repository.dart';

class GetChatReplyUsecase
    implements UseCaseWithParams<ChatMessageEntity, GetChatReplyParams> {
  final BotRepository repository;

  GetChatReplyUsecase(this.repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(
    GetChatReplyParams params,
  ) async {
    return await repository.getChatReply(
      query: params.query,
      history: params.history,
    );
  }
}

// Parameters class for the usecase
class GetChatReplyParams extends Equatable {
  final String query;
  final List<ChatMessageEntity> history;

  const GetChatReplyParams({required this.query, required this.history});

  @override
  List<Object?> get props => [query, history];
}
