import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_delete_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_update_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final UserGetUseCase _userGetUseCase;
  final UserUpdateUsecase _userUpdateUsecase;
  final UserDeleteUsecase _userDeleteUsecase;

  ProfileViewModel({
    required UserGetUseCase userGetUseCase,
    required UserUpdateUsecase userUpdateUseCase,
    required UserDeleteUsecase userDeleteUsecase,
  }) : _userDeleteUsecase = userDeleteUsecase,
       _userUpdateUsecase = userUpdateUseCase,
       _userGetUseCase = userGetUseCase,
       super(ProfileState.initial()) {
    on<LoadProfileEvent>(_onProfileLoad);
    on<DeleteProfileEvent>(_onProfileDelete);
    on<UpdateProfileEvent>(_onProfileUpdate);
    on<ToggleEditModeEvent>(_onToggleEditMode);

    add(LoadProfileEvent());
  }

  Future<void> _onProfileLoad(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userGetUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, onError: failure.message)),
      (user) {
        emit(
          state.copyWith(isLoading: false, userEntity: user, isEditing: false),
        );
      },
    );
  }

  void _onToggleEditMode(
    ToggleEditModeEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isEditing: !(state.isEditing ?? false)));
  }

  Future<void> _onProfileDelete(
    DeleteProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userDeleteUsecase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, onError: failure.message)),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            isProfileDeleted: true,
            userEntity: null,
          ),
        );
      },
    );
  }

  Future<void> _onProfileUpdate(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userUpdateUsecase(event.userEntity);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, onError: failure.message));
        // showMySnackBar(
        //   context: event.context,
        //   message: 'Invalid credentials. Please try again.',
        //   color: Colors.red,
        // );
      },

      (updatedUser) {
        emit(
          state.copyWith(
            isLoading: false,
            userEntity: updatedUser,
            isEditing: false,
          ),
        );
      },
    );
  }
}
