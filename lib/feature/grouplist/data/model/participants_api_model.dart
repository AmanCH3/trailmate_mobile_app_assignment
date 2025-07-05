import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_api_model.dart'; // Assuming you have this

import '../../domain/entity/participant_entity.dart'; // We will create this

part 'participants_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ParticipantApiModel {
  @JsonKey(name: '_id')
  final String? id; // The sub-document ID
  final UserApiModel? user;
  final String? status;
  final DateTime? joinedAt;

  ParticipantApiModel({this.id, this.user, this.status, this.joinedAt});

  factory ParticipantApiModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantApiModelToJson(this);

  ParticipantEntity toEntity() {
    return ParticipantEntity(
      id: id ?? '',
      user: user?.toEntity(), // Assumes UserApiModel has toEntity()
      status: status ?? 'pending',
      joinedAt: joinedAt ?? DateTime.now(),
    );
  }
}
