import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/model/group_api_model.dart';

part 'get_groups_by_id_dto.g.dart';

@JsonSerializable()
class GetGroupsByIdDto {
  final bool success;

  final String message;

  final GroupApiModel data;

  const GetGroupsByIdDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetGroupsByIdDto.fromJson(Map<String, dynamic> json) =>
      _$GetGroupsByIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetGroupsByIdDtoToJson(this);
}
