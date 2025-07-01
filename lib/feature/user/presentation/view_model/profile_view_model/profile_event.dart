import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class ToggleEditModeEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final UserEntity userEntity;

  const UpdateProfileEvent({required this.userEntity});

  @override
  List<Object?> get props => [userEntity];
}

class DeleteProfileEvent extends ProfileEvent {}
