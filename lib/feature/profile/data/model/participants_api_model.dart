import 'package:json_annotation/json_annotation.dart';

import '../../../user/data/model/user_api_model.dart';
import '../../domain/entity/participant_entity.dart';

part 'participants_api_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
) // explicitToJson needed for nested UserApiModel
class ParticipantApiModel {
  @JsonKey(name: '_id')
  final String participantId;
  final UserApiModel user;
  final String status;

  ParticipantApiModel({
    required this.participantId,
    required this.user,
    required this.status,
  });

  factory ParticipantApiModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantApiModelToJson(this);

  // Conversion method to the Domain Entity
  ParticipantEntity toEntity() => ParticipantEntity(
    id: participantId,
    user: user.toEntity(), // Convert the nested user object as well
    status: status,
  );
}
