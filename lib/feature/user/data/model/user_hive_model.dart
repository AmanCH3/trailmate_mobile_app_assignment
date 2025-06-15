import 'package:hive_flutter/adapters.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String phone;

  UserHiveModel({
    String? userId,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  }) : userId = userId ?? const Uuid().v4();

  UserEntity toEntity() => UserEntity(
    userId: userId,
    name: name,
    email: email,
    password: password,
    phone: phone,
  );

  factory UserHiveModel.fromEntity(UserEntity entity) => UserHiveModel(
    userId: entity.userId,
    name: entity.name,
    email: entity.email,
    password: entity.password,
    phone: entity.phone,
  );
}
