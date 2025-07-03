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
  final TrailApiModel? trail; // Nullable to handle populate failures
  final DateTime date;
  final String? description;
  final int? maxSize;
  final UserApiModel? leader; // Nullable to handle populate failures
  final List<ParticipantApiModel>? participants;
  final String? status;
  final Map<String, dynamic>? meetingPoint;
  final List<String>? requirements;
  final String? difficulty;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
    this.createdAt,
    this.updatedAt,
    this.photos,
    this.comments,
  });

  factory GroupApiModel.fromJson(Map<String, dynamic> json) {
    print('Parsing GroupApiModel with trail data: ${json['trail']}');
    try {
      return _$GroupApiModelFromJson(json);
    } catch (e) {
      print('Error in GroupApiModel.fromJson: $e');
      print('Trail data: ${json['trail']}');
      rethrow;
    }
  }

  static TrailApiModel? _safeTrailFromJson(dynamic trailJson) {
    try {
      if (trailJson == null) return null;
      return TrailApiModel.fromJson(trailJson as Map<String, dynamic>);
    } catch (e) {
      print('Error parsing trail: $e');
      return null; // Return null if parsing fails
    }
  }

  Map<String, dynamic> toJson() => _$GroupApiModelToJson(this);

  GroupEntity toEntity() {
    return GroupEntity(
      id: groupId,
      title: title,
      trail: trail?.toEntity(),
      // Safely convert nullable trail
      date: date,
      description: description ?? '',
      maxSize: maxSize ?? 0,
      leader: leader?.toEntity(),
      // Safely convert nullable leader
      participants: participants?.map((p) => p.toEntity()).toList() ?? [],
      status: status ?? 'upcoming',
      meetingPointDescription: meetingPoint?['description'] as String? ?? '',
      requirements: requirements ?? [],
      difficulty: difficulty ?? 'Not specified',
      createdAt: createdAt ?? DateTime.now(),
      photos: photos ?? [],
      comments: comments?.map((c) => c.toEntity()).toList() ?? [],
    );
  }

  /// Helper method to convert a list of [GroupApiModel] to a list of [GroupEntity].
  static List<GroupEntity> toEntityList(List<GroupApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
