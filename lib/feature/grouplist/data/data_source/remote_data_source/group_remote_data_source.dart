import 'package:dio/dio.dart';
import 'package:trailmate_mobile_app_assignment/app/constant/remote/api_endpoints.dart'; // Your ApiEndpoints
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart'; // Your ApiService
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/dto/get_groups_by_id_dto.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/group_entity.dart';
import '../../../domain/usecase/create_group_usecase.dart';
import '../../dto/get_all_groups_dto.dart';
import '../../model/group_api_model.dart';
import '../group_data_source.dart';

class GroupRemoteDataSource implements IGroupDataSource {
  final ApiService _apiService;

  GroupRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  /// Fetches all groups from the remote API.
  // @override
  // Future<List<GroupEntity>> getAllGroups() async {
  //   try {
  //     final response = await _apiService.dio.get(ApiEndpoints.groups);
  //     if (response.statusCode == 200) {
  //       // Use the DTO to parse the entire response structure.
  //       final getAllGroupsDto = GetAllGroupsDto.fromJson(response.data);
  //       // Convert the list of API models to a list of domain entities.
  //       return GroupApiModel.toEntityList(getAllGroupsDto.data);
  //     } else {
  //       throw ApiFailure(
  //         message: 'Failed to fetch groups from the server.',
  //         statusCode: null,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw ApiFailure(
  //       message: e.response?.data['message'] ?? 'A server error occurred.',
  //       statusCode: null,
  //     );
  //   } catch (e) {
  //     throw ApiFailure(
  //       message: 'An unexpected error occurred: $e',
  //       statusCode: null,
  //     );
  //   }
  // }

  @override
  Future<List<GroupEntity>> getAllGroups() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.groups);
      if (response.statusCode == 200) {
        // Use the DTO to parse the entire response structure.
        final getAllGroupsDto = GetAllGroupsDto.fromJson(response.data);

        // Convert the list of API models to a list of domain entities.
        return GroupApiModel.toEntityList(getAllGroupsDto.data);
      } else {
        throw ApiFailure(
          message: 'Failed to fetch groups from the server.',
          statusCode: null,
        );
      }
    } on DioException catch (e) {
      // --- THIS IS THE MOST IMPORTANT DEBUGGING STEP ---
      print('--- DIO EXCEPTION in getAllGroups ---');
      print('Request Path: ${e.requestOptions.path}');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');

      // Check if there is a response from the server at all
      if (e.response != null) {
        print('Response StatusCode: ${e.response?.statusCode}');
        print(
          'Response Data: ${e.response?.data}',
        ); // This will show you exactly what the server sent back
      } else {
        print(
          'Error: No response received from server. This is likely a connection or timeout issue.',
        );
      }
      print('--- END DIO EXCEPTION ---');
      // --- END OF DEBUGGING STEP ---

      throw ApiFailure(
        message:
            e.response?.data['message'] ??
            'A server error occurred. Check debug console for details.',
        // Update message to be more helpful
        statusCode: e.response?.statusCode, // Pass the status code
      );
    } catch (e, stackTrace) {
      print('--- UNEXPECTED PARSING ERROR in getAllGroups ---');
      print(e.toString());
      print(stackTrace);
      print('-------------------------------------------');
      throw ApiFailure(
        message: 'An unexpected error occurred: $e',
        statusCode: null,
      );
    }
  }

  /// Creates a new group via a multipart/form-data request.
  @override
  Future<GroupEntity> createGroup(
    CreateGroupParams params,
    String token,
  ) async {
    try {
      // 1. Prepare photo files for upload.
      List<MultipartFile> photoFiles = [];
      for (String path in params.photoPaths) {
        photoFiles.add(
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        );
      }

      // 2. Create the FormData payload. Keys must match the backend controller.
      final formData = FormData.fromMap({
        'title': params.title,
        'trail': params.trailId,
        'date': params.date.toIso8601String(),
        'description': params.description,
        'maxSize': params.maxSize.toString(),
        // Ensure maxSize is a string if backend expects it
        'photo': photoFiles,
        // The key 'photo' matches `upload.array('photo', 10)`
      });

      // 3. Make the POST request with the FormData.
      final response = await _apiService.dio.post(
        ApiEndpoints.createGroup,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // The API returns the created group object in the 'data' field.
        final groupApiModel = GroupApiModel.fromJson(response.data['data']);
        return groupApiModel.toEntity();
      } else {
        throw ApiFailure(
          message: 'Failed to create the group.',
          statusCode: null,
        );
      }
    } on DioException catch (e) {
      throw ApiFailure(
        message: e.response?.data['message'] ?? 'A server error occurred.',
        statusCode: null,
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: $e',
        statusCode: null,
      );
    }
  }

  /// Deletes a group from the server.
  @override
  Future<void> deleteGroup(String groupId, String token) async {
    try {
      // Construct the specific URL for the group to be deleted.
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.groups}/$groupId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // A successful deletion might return 200 OK or 204 No Content.
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiFailure(
          message: 'Failed to delete the group.',
          statusCode: null,
        );
      }
      // No data needs to be returned on success.
    } on DioException catch (e) {
      throw ApiFailure(
        message: e.response?.data['message'] ?? 'A server error occurred.',
        statusCode: 500,
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: $e',
        statusCode: 500,
      );
    }
  }

  /// Sends a request to join a specific group.
  @override
  Future<void> requestToJoinGroup({
    required String groupId,
    String? message,
    required String token,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.requestToJoin(groupId),
        data: message != null ? {'message': message} : {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw ApiFailure(
          message: 'Failed to send join request.',
          statusCode: 500,
        );
      }
      // No data needs to be returned on success.
    } on DioException catch (e) {
      throw ApiFailure(
        message: e.response?.data['message'] ?? 'A server error occurred.',
        statusCode: 500,
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<GroupEntity> getGroupById(String groupId) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.groupById(groupId),
      );
      print('Checking the response of groupId : $response');
      if (response.statusCode == 200) {
        final data = response.data;
        final groupByIdDto = GetGroupsByIdDto.fromJson(data);

        final groupModel = GroupApiModel.fromJson(
          groupByIdDto.data as Map<String, dynamic>,
        );
        return groupModel.toEntity();
      } else {
        // Handle unexpected status code
        throw Exception('Failed to fetch courses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle DioException
      throw Exception('Failed to fetch courses: $e');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
