// lib/features/checklist/data/data_source/checklist_remote_data_source_impl.dart

import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/data/data_source/checklist_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/data/model/checklist_api_model.dart';

import '../../../../../app/constant/remote/api_endpoints.dart';

class ChecklistRemoteDataSource implements ICheckListDataSource {
  final ApiService _apiService;

  ChecklistRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  // @override
  // Future<Map<String, List<CheckListApiModel>>> generateCheckList({ // <-- Matches interface
  //   required String experience,
  //   required String duration,
  //   required String weather,
  // }) async {
  //
  // }

  @override
  Future<Map<String, List<CheckListApiModel>>> generateCheckList({
    required String experience,
    required String duration,
    required String weather,
  }) async {
    try {
      // FIX 1: Pass the path and query parameters directly to dio.get()
      final response = await _apiService.dio.get(
        ApiEndpoints.generateCheckList,
        // Use the relative path from your endpoints
        queryParameters: {
          'experience': experience,
          'duration': duration,
          'weather': weather,
        },
      );

      if (response.statusCode == 200) {
        // FIX 2: Use response.data with Dio, not response.body or json.decode()
        final Map<String, dynamic> jsonResponse = response.data;

        // This part remains the same, assuming your API returns a `data` key
        final Map<String, dynamic> data = jsonResponse['data'];

        final Map<String, List<CheckListApiModel>> checklist = {};
        data.forEach((category, items) {
          checklist[category] =
              (items as List)
                  .map((itemJson) => CheckListApiModel.fromJson(itemJson))
                  .toList();
        });
        return checklist;
      } else {
        // This part is fine, but you can get the error message from response.data too
        throw ApiFailure(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'Failed to generate checklist.',
        );
      }
    } on Exception catch (e) {
      // This catch block is good for handling Dio errors, timeouts, etc.
      throw ApiFailure(message: e.toString(), statusCode: null);
    }
  }
}
