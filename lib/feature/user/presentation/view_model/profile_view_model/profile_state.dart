import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool? isEditing;
  final bool? isProfileDeleted;

  final UserEntity? userEntity;
  final String? onError;

  ProfileState({
    required this.isLoading,
    this.isEditing,
    this.isProfileDeleted,
    required this.userEntity,
    this.onError,
  });

  factory ProfileState.initial() {
    return ProfileState(
      isLoading: false,
      userEntity: null,
      onError: '',
      isEditing: false,
      isProfileDeleted: false,
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    UserEntity? userEntity,
    String? onError,
    bool? isEditing,
    bool? isProfileDeleted,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userEntity: userEntity ?? this.userEntity,
      onError: onError ?? this.onError,
      isEditing: isEditing ?? this.isEditing,
      isProfileDeleted: isProfileDeleted ?? this.isProfileDeleted,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    isLoading,
    userEntity,
    onError,
    isEditing,
    isLoading,
  ];
}
