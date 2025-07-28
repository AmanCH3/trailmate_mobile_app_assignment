import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String email, String password);

  // user profile ==========
  Future<Either<Failure, UserEntity>> getUser(String? token);

  Future<Either<Failure, UserEntity>> updateUser(
    UserEntity user,
    String? token,
  );

  Future<Either<Failure, void>> deleteUser(String? token);

  Future<Either<Failure, void>> saveAuthToken(String token);

  UserEntity? getCurrentUser();
  Future<Either<Failure, void>> updateMyStats(int steps, String? token);
}
