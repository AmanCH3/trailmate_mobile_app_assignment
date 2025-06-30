import 'package:equatable/equatable.dart';

import '../../../profile/domain/entity/participant_entity.dart';
import '../../../user/domain/entity/user_entity.dart';

class GroupEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int maxSize;
  final UserEntity leader;
  final List<ParticipantEntity> participants;
  final List<String> photos;
  final String difficulty;

  // Add other fields like trail, meetingPoint, etc. as needed

  const GroupEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.maxSize,
    required this.leader,
    required this.participants,
    required this.photos,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [id, title, date, leader];
}
