import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart'; // Assuming you have this

class CommentEntity extends Equatable {
  final String id;
  final UserEntity? user;
  final String text;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    this.user,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, user, text, createdAt];
}
