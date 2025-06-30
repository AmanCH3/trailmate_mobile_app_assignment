import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_enum.dart';

import 'completed_trail_entity.dart';
import 'emergency_entity.dart';
import 'stats_entity.dart';

class UserEntity extends Equatable {
  final String? userId; // from mongo
  final String name;
  final String email;
  final String phone;
  final String password;

  final HikerType? hikerType;
  final AgeGroup? ageGroup;
  final EmergencyContactEntity? emergencyContact;
  final String? bio;
  final String? profileImage;
  final Role? role;
  final Subscription? subscription;
  final bool? active;
  final StatsEntity? stats;
  final List<String>? achievements; // List of Achievement IDs
  final List<CompletedTrailEntity>? completedTrails;

  /// Password is intentionally omitted from the entity.
  // It should only be handled during sign-up/login and not stored in the app state.

  const UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,

    this.hikerType,
    this.ageGroup,
    this.emergencyContact,
    this.bio,
    this.profileImage,
     this.role,
    this.subscription,
    this.active,
    this.stats,
    this.achievements,
    this.completedTrails,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    phone,
    hikerType,
    ageGroup,
    emergencyContact,
    bio,
    profileImage,
    role,
    subscription,
    active,
    stats,
    achievements,
    completedTrails,
  ];
}
