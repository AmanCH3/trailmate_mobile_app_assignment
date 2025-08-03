import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/model/trail_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_api_model.dart';

part 'step_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StepApiModel {
  @JsonKey(name: '_id')
  final String stepId;

  final UserApiModel user;

  final TrailApiModel trail;

  final int step;

  final DateTime timeStamps;

  StepApiModel({
    required this.stepId,
    required this.user,
    required this.trail,
    required this.step,
    required this.timeStamps,
  });

  factory StepApiModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StepApiModelFromJson(json);
    } catch (e) {
      print('Error in GroupApiModel.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$StepApiModelToJson(this);

  StepEntity toEntity() {
    return StepEntity(
      stepId: stepId,
      user: user.toEntity(),
      step: step,
      timeStamps: timeStamps,
      trail: trail.toEntity(),
    );
  }

  static List<StepEntity> toEntityList(List<StepApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
