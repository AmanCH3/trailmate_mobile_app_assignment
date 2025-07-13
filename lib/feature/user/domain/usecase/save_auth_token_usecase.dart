import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/repository/remote_repository/user_remote_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class SaveAuthTokenUseCase implements UseCaseWithParams<void, String> {
  final IUserRepository _userRepository;

  SaveAuthTokenUseCase({required UserRemoteRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(String token) async {
    return await _userRepository.saveAuthToken(token);
  }
}
