import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/model/trail_api_model.dart';

part 'get_all_trail_dto.g.dart';

@JsonSerializable()
class GetAllTrailDto {
  final bool success;

  final int count;

  final List<TrailApiModel> data;

  const GetAllTrailDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllTrailDtoToJson(this);

  factory GetAllTrailDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllTrailDtoFromJson(json);
}
