import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';

class UserLogoutUseCase implements UseCaseWithoutParams<void> {
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLogoutUseCase({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call() async {
    return await _tokenSharedPrefs.clearToken();
  }
}
