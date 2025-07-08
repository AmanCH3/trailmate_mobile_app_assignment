import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';

class GetMessageHistoryParams extends Equatable {
  final String groupId;

  const GetMessageHistoryParams({required this.groupId});

  @override
  // TODO: implement props
  List<Object?> get props => [groupId];
}

class GetMessageHistoryUseCase
    implements UseCaseWithParams<List<MessageEntity>, GetMessageHistoryParams> {
  final IChatRepository _chatRepository;

  GetMessageHistoryUseCase(IChatRepository chatRepository)
    : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
    GetMessageHistoryParams params,
  ) async {
    return await _chatRepository.getMessageHistory(params.groupId);
  }
}
