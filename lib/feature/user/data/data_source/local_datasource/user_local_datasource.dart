// feature/user/data/data_source/user_local_data_source.dart

import 'package:trailmate_mobile_app_assignment/core/network/local/hive_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/user_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_hive_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;
  String? _loggedInUserEmail;

  UserLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    final userData = await _hiveService.login(email, password);
    if (userData != null) {
      _loggedInUserEmail = email;
      return "Login successful";
    } else {
      throw Exception('Invalid email or password');
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    // Correct: uses the static factory method
    final userHiveModel = UserHiveModel.fromEntity(entity);
    await _hiveService.register(userHiveModel);
  }

  @override
  Future<UserEntity> getUser(String? token) async {
    if (_loggedInUserEmail != null) {
      final user = await _hiveService.getUserByEmail(_loggedInUserEmail!);
      if (user != null) {
        // CORRECTED: Call the instance method on the 'user' object
        return user.toEntity();
      }
    }
    throw Exception("No cached user found. Please login online first.");
  }

  @override
  Future<UserEntity> updateUser(UserEntity user, String? token) async {
    final userHiveModel = UserHiveModel.fromEntity(user);
    await _hiveService.updateUser(userHiveModel);
    return user;
  }

  @override
  Future<void> deleteUser(String? token) async {
    if (_loggedInUserEmail != null) {
      await _hiveService.deleteUserByEmail(_loggedInUserEmail!);
      _loggedInUserEmail = null;
    } else {
      throw Exception("No logged-in user to delete from cache.");
    }
  }

  @override
  Future<void> updateMyStats(int steps, String? token) {
    throw UnimplementedError("Stat updates require an internet connection.");
  }
}
