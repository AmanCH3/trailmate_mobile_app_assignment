import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/checklist_item_entity.dart'; // Or CheckListEntity

// This line links to the generated file
part 'checklist_api_model.g.dart';

@JsonSerializable()
class CheckListApiModel {
  final int id;

  // Use @JsonKey to map the JSON key "text" to your Dart variable "name".
  @JsonKey(name: 'text')
  final String name;

  final bool checked;

  CheckListApiModel({
    required this.id,
    required this.name,
    required this.checked,
  });

  // These will be generated for you by build_runner
  factory CheckListApiModel.fromJson(Map<String, dynamic> json) =>
      _$CheckListApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckListApiModelToJson(this);

  // Your toEntity method remains the same and is still correct.
  CheckListEntity toEntity() {
    return CheckListEntity(id: id, name: name, checked: checked);
  }
}
