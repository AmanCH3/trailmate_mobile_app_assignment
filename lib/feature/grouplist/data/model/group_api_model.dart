import 'package:json_annotation/json_annotation.dart';

import '../../../trail/data/model/trail_api_model.dart';
import '../../../user/data/model/user_api_model.dart';
import '../../domain/entity/group_entity.dart';
import 'comment_api_model.dart';
import 'participants_api_model.dart';

part 'group_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupApiModel {
  @JsonKey(name: '_id')
  final String groupId;
  final String title;
  final TrailApiModel? trail;
  final DateTime date;
  final String? description;
  final int? maxSize;
  final UserApiModel? leader;
  final List<ParticipantApiModel>? participants;
  final String? status;
  final Map<String, dynamic>? meetingPoint;
  final List<String>? requirements;
  final String? difficulty;
  final List<String>? photos;
  final List<CommentApiModel>? comments;

  GroupApiModel({
    required this.groupId,
    required this.title,
    this.trail,
    required this.date,
    this.description,
    this.maxSize,
    this.leader,
    this.participants,
    this.status,
    this.meetingPoint,
    this.requirements,
    this.difficulty,
    this.photos,
    this.comments,
  });

  factory GroupApiModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$GroupApiModelFromJson(json);
    } catch (e) {
      print('Error in GroupApiModel.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$GroupApiModelToJson(this);

  GroupEntity toEntity() {
    return GroupEntity(
      id: groupId,
      title: title,
      trail: trail?.toEntity(),
      date: date,
      description: description ?? '',
      maxSize: maxSize ?? 0,
      leader: leader?.toEntity(),
      participants: participants?.map((p) => p.toEntity()).toList() ?? [],
      status: status ?? 'upcoming',
      meetingPointDescription: meetingPoint?['description']?.toString() ?? '',
      requirements: requirements ?? [],
      difficulty: difficulty ?? 'Moderate',
      photos: photos ?? [],
      comments: comments?.map((c) => c.toEntity()).toList() ?? [],
    );
  }

  static List<GroupEntity> toEntityList(List<GroupApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
