// feature/user/data/data_source/user_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:trailmate_mobile_app_assignment/app/constant/remote/api_endpoints.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/user_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  UserRemoteDataSource({
    required ApiService apiService,
    required this.tokenSharedPrefs,
  }) : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      print('login response $response');

      if (response.statusCode == 200) {
        // Assuming the token is in response.data['token']
        final String token = response.data['token'];

        if (token.isNotEmpty) {
          tokenSharedPrefs.saveToken(token);
          return token;
        } else {
          throw Exception("Failed to login: Token is missing in response");
        }
      } else {
        throw Exception("Failed to login: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      // Provide more specific error from server response if available
      throw Exception(
        "Failed to login: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception("Failed to login: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    try {
      final userApiModel = UserApiModel.fromEntity(entity);
      final data =
          userApiModel.toJson()..removeWhere((key, value) => value == null);

      await _apiService.dio.post(ApiEndpoints.register, data: data);
    } on DioException catch (e) {
      throw Exception(
        "Failed to register user: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<UserEntity> getUser(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getUser,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('get user response $response');

      if (response.statusCode == 200) {
        final userJson = response.data['data'] ?? response.data;
        final userApiModel = UserApiModel.fromJson(userJson);
        return userApiModel.toEntity();
      } else {
        throw Exception('Failed to fetch user');
      }
    } on DioException catch (e) {
      throw Exception(
        "Failed to fetch user: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user, String? token) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final data =
          userApiModel.toJson()..removeWhere((key, value) => value == null);

      final response = await _apiService.dio.put(
        ApiEndpoints.updateUser,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final updatedUserJson = response.data['data'] ?? response.data;
        final updatedUserApiModel = UserApiModel.fromJson(updatedUserJson);
        return updatedUserApiModel.toEntity();
      } else {
        throw Exception("Failed to update user: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception(
        "Failed to update user: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String? token) async {
    try {
      await _apiService.dio.delete(
        ApiEndpoints.deleteUser,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(
        "Deletion of user failed: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception('Deletion of user failed: $e');
    }
  }

  @override
  Future<void> updateMyStats(int steps, String? token) async {
    try {
      final data = {'steps': steps};
      await _apiService.dio.patch(
        ApiEndpoints.updateMyStats,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(
        "Failed to update stats: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
