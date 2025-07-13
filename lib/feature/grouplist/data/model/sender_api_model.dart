import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/sender_entity.dart';

part 'sender_api_model.g.dart';

@JsonSerializable()
class SenderApiModel {
  @JsonKey(name: '_id')
  final String senderId;

  final String? name;

  final String? profileImage;

  SenderApiModel({required this.senderId, this.name, this.profileImage});

  factory SenderApiModel.fromJson(Map<String, dynamic> json) =>
      _$SenderApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SenderApiModelToJson(this);

  SenderEntity toEntity() {
    return SenderEntity(
      senderId: senderId,
      name: name,
      profileImage: profileImage,
    );
  }
}
