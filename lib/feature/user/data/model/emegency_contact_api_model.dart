import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/emergency_entity.dart';
part 'emegency_contact_api_model.g.dart';

@JsonSerializable()
class EmergencyContactApiModel extends Equatable {
  final String name;
  final String phone;

  const EmergencyContactApiModel({required this.name, required this.phone});

  factory EmergencyContactApiModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactApiModelToJson(this);

  EmergencyContactEntity toEntity() {
    return EmergencyContactEntity(name: name, phone: phone);
  }

  factory EmergencyContactApiModel.fromEntity(EmergencyContactEntity entity) {
    return EmergencyContactApiModel(name: entity.name, phone: entity.phone);
  }

  @override
  List<Object?> get props => [name, phone];
}
