import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class UserUpdateUsecase implements UseCaseWithParams<UserEntity, UserEntity> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserUpdateUsecase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
       _iUserRepository = iUserRepository;

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (token) async => await _iUserRepository.updateUser(params, token),
    );
  }
}
