import 'package:json_annotation/json_annotation.dart';

import '../../../profile/data/model/participants_api_model.dart';
import '../../../user/data/model/user_api_model.dart';
import '../../domain/entity/group_entity.dart';

part 'group_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupApiModel {
  @JsonKey(name: '_id')
  final String groupId;
  final String title;
  final String description;
  final DateTime date;
  final int maxSize;
  final UserApiModel leader;
  final List<ParticipantApiModel> participants;
  final List<String> photos;
  final String difficulty;

  GroupApiModel({
    required this.groupId,
    required this.title,
    required this.description,
    required this.date,
    required this.maxSize,
    required this.leader,
    required this.participants,
    required this.photos,
    required this.difficulty,
  });

  factory GroupApiModel.fromJson(Map<String, dynamic> json) =>
      _$GroupApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupApiModelToJson(this);

  /// Converts the Data-layer [GroupApiModel] to a Domain-layer [GroupEntity].
  /// This is a crucial part of separating layers in Clean Architecture.
  GroupEntity toEntity() {
    return GroupEntity(
      id: groupId,
      title: title,
      description: description,
      date: date,
      maxSize: maxSize,
      leader: leader.toEntity(),
      participants: participants.map((p) => p.toEntity()).toList(),
      photos: photos,
      difficulty: difficulty,
    );
  }

  /// Helper method to convert a list of [GroupApiModel] to a list of [GroupEntity].
  static List<GroupEntity> toEntityList(List<GroupApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
