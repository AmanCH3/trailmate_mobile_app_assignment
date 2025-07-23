import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';

abstract interface class IStepDataSource {
  Future<void> saveSteps(StepEntity entity);

  Future<int> getTotalSteps();
}
