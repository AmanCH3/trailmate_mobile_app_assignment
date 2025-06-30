import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class UserDeleteUsecase implements UseCaseWithoutParams<void> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserDeleteUsecase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _iUserRepository = iUserRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (token) async => await _iUserRepository.deleteUser(token),
    );
  }
}
