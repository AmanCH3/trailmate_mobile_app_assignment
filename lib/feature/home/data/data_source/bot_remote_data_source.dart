import 'package:dio/dio.dart';
import 'package:trailmate_mobile_app_assignment/app/constant/remote/api_endpoints.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/data/data_source/bot_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/data/model/bot_model_request.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/data/model/bot_model_response.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService _apiService;

  ChatRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<ChatResponseModel> getChatReply({
    required String query,
    required List<ChatMessageEntity> history,
  }) async {
    try {
      final requestModel = ChatRequestModel.fromEntities(
        query: query,
        historyEntities: history,
      );
      final response = await _apiService.dio.post(
        ApiEndpoints.chatQuery,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200) {
        return ChatResponseModel.fromJson(response.data);
      } else {
        throw Exception("Chatbot failed to respond: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception(
        "Chatbot connection error: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
