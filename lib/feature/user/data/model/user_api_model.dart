import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String? id;

  final String name;

  final String email;

  final String phone;

  final String? password;

  const UserApiModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  //to entity
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      password: password ?? '',
      phone: phone,
      userId: id,
    );
  }

  // from Enity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, password, phone, email];
}
