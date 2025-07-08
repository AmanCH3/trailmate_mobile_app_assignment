import 'package:trailmate_mobile_app_assignment/feature/checklist/data/model/checklist_api_model.dart';

abstract interface class ICheckListDataSource {
  Future<Map<String, List<CheckListApiModel>>> generateCheckList({
    required String experience,
    required String duration,
    required String weather,
  });
}
