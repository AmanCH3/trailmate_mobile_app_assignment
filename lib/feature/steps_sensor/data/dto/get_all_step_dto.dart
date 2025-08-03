import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/data/model/step_api_model.dart';
part 'get_all_step_dto.g.dart';

@JsonSerializable()
class GetAllStepDto {
  final bool success;
  final String message;
  final List<StepApiModel> data;

  const GetAllStepDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetAllStepDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllStepDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllStepDtoToJson(this);
}
