import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserEntity? userEntity;
  final String? onError;

  ProfileState({
    required this.isLoading,
    required this.userEntity,
    this.onError,
  });

  factory ProfileState.initial() {
    return ProfileState(isLoading: false, userEntity: null, onError: '');
  }

  ProfileState copyWith({
    bool? isLoading,
    UserEntity? userEntity,
    String? onError,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userEntity: userEntity ?? this.userEntity,
      onError: onError ?? this.onError,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, userEntity, onError];
}
