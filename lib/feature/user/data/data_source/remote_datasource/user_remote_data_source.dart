import 'package:dio/dio.dart';
import 'package:trailmate_mobile_app_assignment/app/constant/remote/api_endpoints.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/user_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  // Future<void> createUser(UserEntity entity) async {
  //   try {
  //     final userApiModel = UserApiModel.fromEntity(entity);
  //     final response = await _apiService.dio.post(
  //       ApiEndpoints.register,
  //       data: userApiModel.toJson(),
  //     );
  //     if (response.statusCode == 200) {
  //       return;
  //     } else {
  //       throw Exception("Failed to register user : ${response.statusMessage}");
  //     }
  //   } on DioException catch (e) {
  //     throw Exception("Failed to register user : ${e.message}");
  //   } catch (e) {
  //     throw Exception('Failed to register student : $e');
  //   }
  // }
  // @override
  // Future<void> deleteUser(String id) {
  //   // TODO: implement deleteUser
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<List<UserEntity>> getAllUser() {
  //   // TODO: implement getAllUser
  //   throw UnimplementedError();
  // }
  @override
  Future<void> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(
          "Failed to register student : ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to Login Student : ${e.message}");
    } catch (e) {
      throw Exception("failed to login user $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    try {
      final userApiModel = UserApiModel.fromEntity(entity);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          'Failed to register student: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to register student  ${e.message}');
    } catch (e) {
      throw Exception('Registration Failed  : $e');
    }
  }
}
