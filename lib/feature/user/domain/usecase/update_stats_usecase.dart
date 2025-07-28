import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class UpdateMyStatsParams extends Equatable {
  final int steps;
  const UpdateMyStatsParams({required this.steps});

  @override
  List<Object?> get props => [steps];
}

class UpdateMyStatsUseCase
    implements UseCaseWithParams<void, UpdateMyStatsParams> {
  final IUserRepository _userRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UpdateMyStatsUseCase({
    required IUserRepository userRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _userRepository = userRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(UpdateMyStatsParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    if (params.steps <= 0) {
      return Left(
        ApiFailure(
          message: "Steps must be greater than zero.",
          statusCode: 500,
        ),
      );
    }
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => _userRepository.updateMyStats(params.steps, token),
    );
  }
}
