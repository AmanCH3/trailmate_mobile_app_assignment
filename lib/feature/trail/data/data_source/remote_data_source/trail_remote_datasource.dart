import 'package:dio/dio.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/data_source/trail_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/dto/get_all_trail_dto.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/model/trail_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

import '../../../../../app/constant/remote/api_endpoints.dart';

class TrailRemoteDataSource implements ITrailDataSource {
  final ApiService _apiService;

  TrailRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<TrailEnitiy>> getTrails() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllTrails);
    
      if (response.statusCode == 200) {
        GetAllTrailDto getAllTrailDto = GetAllTrailDto.fromJson(response.data);
        return TrailApiModel.toEntityList(getAllTrailDto.data);
      } else {
        throw Exception("Failed to fetch trails : ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch trails : ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occured : $e');
    }
  }
}
