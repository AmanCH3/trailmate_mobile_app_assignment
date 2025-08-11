import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool? isEditing;
  final bool? isProfileDeleted;
  final bool isLoggedOut; // ✨ Added to track logout status
  final bool isUpdateSuccessful;

  final UserEntity? userEntity;
  final String? onError;

  const ProfileState({
    required this.isLoading,
    this.isEditing,
    this.isProfileDeleted,
    this.isLoggedOut = false, // ✨ Default to false
    this.userEntity,
    this.onError,
    this.isUpdateSuccessful = false, // ✨ Added to track update success
  });

  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: false,
      userEntity: null,
      onError: '',
      isEditing: false,
      isProfileDeleted: false,
      isLoggedOut: false,
      isUpdateSuccessful: false, // ✨ Default to false
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    UserEntity? userEntity,
    String? onError,
    bool? isEditing,
    bool? isProfileDeleted,
    bool? isLoggedOut, // ✨ Added to copyWith
    bool? isUpdateSuccessful, // ✨ Added to copyWith
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userEntity: userEntity ?? this.userEntity,
      onError: onError ?? this.onError,
      isEditing: isEditing ?? this.isEditing,
      isProfileDeleted: isProfileDeleted ?? this.isProfileDeleted,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      isUpdateSuccessful: isUpdateSuccessful ?? this.isUpdateSuccessful,
    );
  }

  @override
  // ✨ Corrected the props list
  List<Object?> get props => [
    isLoading,
    userEntity,
    onError,
    isEditing,
    isProfileDeleted,
    isLoggedOut,
    isUpdateSuccessful,
  ];
}
