import 'package:json_annotation/json_annotation.dart';

import '../model/group_api_model.dart';

part 'get_all_groups_dto.g.dart';

@JsonSerializable()
class GetAllGroupsDto {
  final bool success;
  final String message;
  final Map<String, dynamic> pagination;
  final List<GroupApiModel> data;

  const GetAllGroupsDto({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory GetAllGroupsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllGroupsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllGroupsDtoToJson(this);
}
