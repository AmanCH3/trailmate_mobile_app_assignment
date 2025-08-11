import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/core/common/Internet_checker/internet_checker.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/remote_datasource/user_remote_data_source.dart';

import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/repository/user_repository.dart';

// 1. RENAMED the class and added the new dependency
class UserRepositoryImpl implements IUserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource; // <-- ADDED
  final TokenSharedPrefs _tokenSharedPrefs;

  UserEntity? _currentUser;

  // 2. UPDATED the constructor
  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource, // <-- ADDED
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource, // <-- ADDED
       _tokenSharedPrefs = tokenSharedPrefs;

  // 3. IMPLEMENTED Online/Offline logic for each method

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    if (await InternetChecker.isConnected()) {
      // ONLINE: Get token from remote and cache login locally
      try {
        final token = await _remoteDataSource.loginUser(email, password);
        // Also "login" to local source to cache the user's email for offline use
        await _localDataSource.loginUser(email, password);
        return Right(token);
      } catch (e) {
        return Left(ApiFailure(message: e.toString(), statusCode: null));
      }
    } else {
      // OFFLINE: Validate against local cache
      try {
        final message = await _localDataSource.loginUser(email, password);
        return Right(message);
      } catch (e) {
        return Left(
          ApiFailure(message: "Offline: ${e.toString()}", statusCode: null),
        );
      }
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    // Registration should only happen when online
    if (await InternetChecker.isConnected()) {
      try {
        await _remoteDataSource.registerUser(user);
        // Also save to local cache after successful remote registration
        await _localDataSource.registerUser(user);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString(), statusCode: null));
      }
    } else {
      return Left(
        ApiFailure(
          message: "No internet connection to register user.",
          statusCode: null,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(String? token) async {
    if (await InternetChecker.isConnected()) {
      // ONLINE: Get from remote and update cache
      try {
        final user = await _remoteDataSource.getUser(token);
        _currentUser = user;
        // Cache the fresh data locally for offline use
        await _localDataSource.updateUser(user, null);
        return Right(user);
      } catch (e) {
        return Left(ApiFailure(message: e.toString(), statusCode: null));
      }
    } else {
      // OFFLINE: Get from local cache
      try {
        // The token is passed but the local source will ignore it and use its internal state
        final user = await _localDataSource.getUser(token);
        _currentUser = user;
        return Right(user);
      } catch (e) {
        return Left(
          ApiFailure(message: "Offline: ${e.toString()}", statusCode: null),
        );
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
    UserEntity user,
    String? token,
  ) async {
    // Updates should happen online to stay in sync
    if (await InternetChecker.isConnected()) {
      try {
        final updatedUser = await _remoteDataSource.updateUser(user, token);
        _currentUser = updatedUser;
        // Cache the updated user data
        await _localDataSource.updateUser(updatedUser, null);
        return Right(updatedUser);
      } catch (e) {
        return Left(ApiFailure(message: e.toString(), statusCode: null));
      }
    } else {
      return Left(
        ApiFailure(
          message: "No internet connection to update profile.",
          statusCode: null,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String? token) async {
    // Deletion must happen online
    if (await InternetChecker.isConnected()) {
      try {
        await _remoteDataSource.deleteUser(token);
        // Also delete from cache
        await _localDataSource.deleteUser(null);
        _currentUser = null;
        await _tokenSharedPrefs.clearToken();
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString(), statusCode: null));
      }
    } else {
      return Left(
        ApiFailure(
          message: "No internet connection to delete account.",
          statusCode: null,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateMyStats(int steps, String? token) async {
    if (await InternetChecker.isConnected()) {
      try {
        await _remoteDataSource.updateMyStats(steps, token);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString(), statusCode: null));
      }
    } else {
      // For non-critical updates, we can fail gracefully
      return Left(
        ApiFailure(
          message: "Offline. Stats will sync when you're back online.",
          statusCode: null,
        ),
      );
    }
  }

  // These methods do not need online/offline logic as they deal with
  // local shared preferences or in-memory data.

  @override
  Future<Either<Failure, void>> saveAuthToken(String token) async {
    try {
      await _tokenSharedPrefs.saveToken(token);
      return const Right(null);
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
