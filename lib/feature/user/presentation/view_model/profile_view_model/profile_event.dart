import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UserEntity userEntity;

  const UpdateProfileEvent({required this.userEntity});

  @override
  // TODO: implement props
  List<Object?> get props => [userEntity];
}

class DeleteProfileEvent extends ProfileEvent {}
