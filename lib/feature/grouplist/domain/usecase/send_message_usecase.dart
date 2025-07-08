import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';

class SendMessageParams extends Equatable {
  final String text;
  final String groupId;
  final String senderId;

  const SendMessageParams({
    required this.text,
    required this.groupId,
    required this.senderId,
  });

  @override
  List<Object?> get props => [text, groupId, senderId];
}

class SendMessageUseCase implements UseCaseWithParams<void, SendMessageParams> {
  final IChatRepository chatRepository;

  SendMessageUseCase(this.chatRepository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await chatRepository.sendMessage(
      text: params.text,
      groupId: params.groupId,
      senderId: params.senderId,
    );
  }
}
