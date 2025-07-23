import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/remote_datasource/user_remote_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserEntity? _currentUser;

  UserRemoteRepository({
    required UserRemoteDataSource userRemoteDataSource,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _userRemoteDataSource = userRemoteDataSource,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final token = await _userRemoteDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String? token) async {
    try {
      await _userRemoteDataSource.deleteUser(token);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(String? token) async {
    try {
      final user = await _userRemoteDataSource.getUser(token);
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(statusCode: null, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
    UserEntity user,
    String? token,
  ) async {
    try {
      final updateUser = await _userRemoteDataSource.updateUser(user, token);
      return Right(updateUser);
    } catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthToken(String token) async {
    try {
      await _tokenSharedPrefs.saveToken(token);
      return const Right(
        null,
      ); // Right(null) is the convention for a void success
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to save auth token.', statusCode: null),
      );
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return _currentUser;
  }
}
