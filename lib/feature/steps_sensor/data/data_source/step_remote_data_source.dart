// lib/feature/steps_sensor/data/data_source/step_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/data/data_source/step_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';

import '../../../../app/constant/remote/api_endpoints.dart';

class StepRemoteDataSource implements IStepDataSource {
  final ApiService _apiService;

  StepRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<int> getTotalSteps() async {
    try {
      // THE INTERCEPTOR WILL ADD THE TOKEN AUTOMATICALLY!
      // Notice how clean this is. No more options or headers here.
      final response = await _apiService.dio.get(ApiEndpoints.totalSteps);

      if (response.statusCode == 200) {
        return response.data['totalSteps'] ?? 0;
      }
      // This part is likely unreachable if your interceptor and dio are set up
      // to throw on non-2xx status codes, but it's good for safety.
      throw ApiFailure(
        statusCode: response.statusCode,
        message: 'Failed to get total steps',
      );
    } on DioException catch (e) {
      throw ApiFailure(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'A server error occurred',
      );
    } catch (e) {
      throw ApiFailure(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> saveSteps(StepEntity entity) async {
    try {
      final Map<String, dynamic> stepData = {
        'userId': entity.user?.userId,
        // Check if your backend needs this. It can get it from the token.
        'trailId': entity.trail?.trailId,
        'steps': entity.step,
      };

      final response = await _apiService.dio.post(
        ApiEndpoints.saveSteps,
        data: stepData,
      );
      if (response.statusCode != 200) {
        throw ApiFailure(
          statusCode: response.statusCode,
          message: 'Failed to save steps',
        );
      }
    } on DioException catch (e) {
      throw ApiFailure(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'A server error occurred',
      );
    } catch (e) {
      throw ApiFailure(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
