import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, void>> createUser(UserEntity user) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUser() {
    // TODO: implement getAllUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final result = await _userLocalDataSource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "failed to register : $e"));
    }
  }
}
