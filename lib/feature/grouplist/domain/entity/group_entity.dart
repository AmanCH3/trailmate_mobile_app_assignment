import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart'; // Assuming
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart'; // Assuming

import 'comment_entity.dart';
import 'participant_entity.dart';

class GroupEntity extends Equatable {
  final String id;
  final String title;
  final TrailEnitiy? trail;
  final DateTime date;
  final String description;
  final int maxSize;
  final UserEntity? leader;
  final List<ParticipantEntity> participants;
  final String status;
  final String meetingPointDescription;
  final List<String> requirements;
  final String difficulty;
  final List<String> photos;
  final List<CommentEntity>? comments;

  const GroupEntity({
    required this.id,
    required this.title,
    this.trail,
    required this.date,
    required this.description,
    required this.maxSize,
    this.leader,
    required this.participants,
    required this.status,
    required this.meetingPointDescription,
    required this.requirements,
    required this.difficulty,
    required this.photos,
    this.comments,
  });

  @override
  List<Object?> get props => [id, title, date, trail, leader, status];
}
