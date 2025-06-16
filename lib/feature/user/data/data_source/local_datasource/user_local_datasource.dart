import 'package:trailmate_mobile_app_assignment/core/network/local/hive_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/user_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_hive_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> createUser(UserEntity entity) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(entity);
      await _hiveService.addUser(userHiveModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _hiveService.deleteUser(id);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<UserEntity>> getAllUser() async {
    try {
      return _hiveService.getAllUsers().then((value) {
        return value.map((e) => e.toEntity()).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final userData = await _hiveService.login(email, password);
      if (userData != null && userData.password == password) {
        return "Login successful";
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      throw Exception('Login Failed : $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(entity);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration Failed : $e");
    }
  }
}
