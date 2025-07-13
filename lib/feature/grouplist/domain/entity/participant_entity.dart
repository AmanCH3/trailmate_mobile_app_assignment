import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class ParticipantEntity extends Equatable {
  final String id;
  final UserEntity? user; // Can be null if populate fails
  final String status;
  final DateTime? joinedAt;

  const ParticipantEntity({
    required this.id,
    this.user,
    required this.status,
    this.joinedAt,
  });

  @override
  List<Object?> get props => [id, user, status, joinedAt];
}
