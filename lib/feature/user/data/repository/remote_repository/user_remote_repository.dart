import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/remote_datasource/user_remote_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository({required UserRemoteDataSource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;

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
}
