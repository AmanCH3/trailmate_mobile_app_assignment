import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/stats_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_enum.dart'; // Make sure to import your enums

import 'completed_trail_api_model.dart';
import 'emegency_contact_api_model.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(defaultValue: '')
  final String? name;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String password;
  @JsonKey(defaultValue: '')
  final String? hikerType; // "new" or "experienced"
  final String? ageGroup; // "18-24", "24-35", etc.
  final EmergencyContactApiModel? emergencyContact;
  final String? bio;
  final String? profileImage;
  final DateTime? joinDate;
  final String? role; // "user", "guide", "admin"
  final String? subscription; // "basic", "pro", "premium"
  final bool? active;
  final StatsApiModel? stats;
  final List<String>? achievements; // Achievement IDs
  final List<CompletedTrailApiModel>? completedTrails;

  // Timestamps from MongoDB
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserApiModel({
    this.id,
    this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.hikerType,
    this.ageGroup,
    this.emergencyContact,
    this.bio,
    this.profileImage,
    this.joinDate,
    this.role,
    this.subscription,
    this.active,
    this.stats,
    this.achievements,
    this.completedTrails,
    this.createdAt,
    this.updatedAt,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  // to entity
  UserEntity toEntity() {
    AgeGroup? mapAgeGroup(String? value) {
      if (value == null) return null;
      switch (value) {
        case '18-24':
          return AgeGroup.age18to24;
        case '25-35':
          return AgeGroup.age24to35;
        case '36-45':
          return AgeGroup.age35to44;
        case '46-55':
          return AgeGroup.age45to54;
        case '56+':
          return AgeGroup.age55to64;
        default:
          return null; // Handle unknown values
      }
    }

    return UserEntity(
      userId: id,
      name: name,
      email: email,
      phone: phone,
      password: password,

      hikerType: switch (hikerType) {
        'new' => HikerType.newbie,
        'experienced' => HikerType.experienced,
        _ => null,
      },
      ageGroup: mapAgeGroup(ageGroup),
      role: switch (role) {
        'user' => Role.user,
        'guide' => Role.guide,
        'admin' => Role.admin,
        _ => null,
      },
      subscription: switch (subscription) {
        'basic' => Subscription.basic,
        'pro' => Subscription.pro,
        'premium' => Subscription.premium,
        _ => null,
      },
      emergencyContact: emergencyContact?.toEntity(),
      bio: bio,
      profileImage: profileImage,
      active: active,
      stats: stats?.toEntity(),
      achievements: achievements,
      completedTrails: completedTrails?.map((ct) => ct.toEntity()).toList(),
    );
  }

  // from Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    String? mapAgeGroupToString(AgeGroup? ageGroup) {
      if (ageGroup == null) return null;
      switch (ageGroup) {
        case AgeGroup.age18to24:
          return '18-24';
        case AgeGroup.age24to35:
          return '25-35';
        case AgeGroup.age35to44:
          return '36-45';
        case AgeGroup.age45to54:
          return '46-55';
        case AgeGroup.age55to64:
          return '56-65';
        case AgeGroup.age65plus:
          return '56+';
      }
    }

    return UserApiModel(
      id: entity.userId,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
      hikerType: entity.hikerType?.name,
      ageGroup: mapAgeGroupToString(entity.ageGroup),
      role: entity.role?.name,
      subscription: entity.subscription?.name,
      // Ensure EmergencyContact can be constructed from an entity, and handle nulls
      emergencyContact:
          entity.emergencyContact != null
              ? EmergencyContactApiModel.fromEntity(entity.emergencyContact!)
              : null,
      bio: entity.bio,
      profileImage: entity.profileImage,
      active: entity.active,

      // Ensure Stats can be constructed from an entity, and handle nulls
      stats:
          entity.stats != null ? StatsApiModel.fromEntity(entity.stats!) : null,

      achievements: entity.achievements,
      completedTrails:
          entity.completedTrails
              ?.map((e) => CompletedTrailApiModel.fromEntity(e))
              .toList(),

      // joinDate, createdAt, updatedAt are usually read-only from the server,
      // so they are not included when creating a model from an entity.
    );
  }

  // Convert API List to Entity List
  static List<UserEntity> toEntityList(List<UserApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  // Correctly implement props for Equatable
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    password,
    hikerType,
    ageGroup,
    emergencyContact,
    bio,
    profileImage,
    joinDate,
    role,
    subscription,
    active,
    stats,
    achievements,
    completedTrails,
    createdAt,
    updatedAt,
  ];
}
