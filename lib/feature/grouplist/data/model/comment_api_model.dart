import 'package:json_annotation/json_annotation.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/comment_entity.dart'; // We will create this
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_api_model.dart'; // Assuming you have this

part 'comment_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final UserApiModel? user;
  final String? text;
  final DateTime? createdAt; // Note: Your schema has a typo 'createAt'

  CommentApiModel({this.id, this.user, this.text, this.createdAt});

  // Note: Handle the typo from your Mongoose schema here.
  // If you fix it in Mongoose to 'createdAt', you can remove this @JsonKey.
  @JsonKey(name: 'createAt')
  factory CommentApiModel.fromJson(Map<String, dynamic> json) =>
      _$CommentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentApiModelToJson(this);

  CommentEntity toEntity() {
    return CommentEntity(
      id: id ?? '',
      user: user?.toEntity(),
      text: text ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
