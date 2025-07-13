import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/chat_repository.dart';

import '../../../../core/error/failure.dart';

class DisconnectUseCase implements UseCaseWithoutParams<void> {
  final IChatRepository chatRepository;

  DisconnectUseCase(this.chatRepository);

  @override
  Future<Either<Failure, void>> call() async {
    return await chatRepository.disconnect();
  }
}
