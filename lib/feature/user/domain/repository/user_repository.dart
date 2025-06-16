import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> createUser(UserEntity user);

  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String email, String password);

  Future<Either<Failure, List<UserEntity>>> getAllUser();

  Future<Either<Failure, void>> deleteUser(String id);
}
