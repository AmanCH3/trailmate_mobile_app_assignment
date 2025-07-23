import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';

// This use case has no parameters and returns a nullable String (the token).
class CheckAuthStatusUseCase implements UseCaseWithoutParams<String?> {
  final TokenSharedPrefs _tokenSharedPrefs;

  CheckAuthStatusUseCase({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, String?>> call() async {
    // We simply call the getToken method from your existing TokenSharedPrefs.
    // It already correctly handles potential errors.
    return await _tokenSharedPrefs.getToken();
  }
}
