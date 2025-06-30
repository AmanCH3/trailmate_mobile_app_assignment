import 'package:equatable/equatable.dart';

import '../../../user/domain/entity/user_entity.dart';

class ParticipantEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String status; // 'pending', 'confirmed', 'declined'

  const ParticipantEntity({
    required this.id,
    required this.user,
    required this.status,
  });

  @override
  List<Object?> get props => [id, user, status];
}
