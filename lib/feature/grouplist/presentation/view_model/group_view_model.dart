import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';

import '../../domain/usecase/GetAll_group_usecase.dart';
import '../../domain/usecase/create_group_usecase.dart';
import '../../domain/usecase/request_to_join_usecase.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupViewModel extends Bloc<GroupEvent, GroupState> {
  final UserGetUseCase _userGetUseCase;
  final GetAllGroupsUseCase _getAllGroupsUseCase;
  final CreateGroupUseCase _createGroupUseCase;
  final RequestToJoinGroupUseCase _requestToJoinGroupUseCase;

  String? currentUserId;

  GroupViewModel({
    required GetAllGroupsUseCase getAllGroupsUseCase,
    required CreateGroupUseCase createGroupUseCase,
    required RequestToJoinGroupUseCase requestToJoinGroupUseCase,
    required UserGetUseCase userGetUseCase,
  }) : _getAllGroupsUseCase = getAllGroupsUseCase,
       _createGroupUseCase = createGroupUseCase,
       _requestToJoinGroupUseCase = requestToJoinGroupUseCase,
       _userGetUseCase = userGetUseCase,
       super(GroupInitial()) {
    on<FetchAllGroupsEvent>(_onFetchAllGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<RequestToJoinGroupEvent>(_onRequestToJoin);

    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userResult = await _userGetUseCase();
    userResult.fold(
      (failure) {
        currentUserId = null;
      },
      (user) {
        currentUserId = user.userId;
      },
    );
    add(FetchAllGroupsEvent());
  }

  Future<void> _onFetchAllGroups(
    FetchAllGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    final result = await _getAllGroupsUseCase();

    result.fold(
      (failure) => emit(GroupFailure(message: failure.message)),
      (groups) => emit(GroupsLoaded(groups: groups)),
    );
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await _createGroupUseCase(event.params);
    result.fold(
      (failure) => emit(GroupFailure(message: failure.message)),
      (_) => emit(
        const GroupActionSuccess(message: 'Group created successfully!'),
      ),
    );

    add(FetchAllGroupsEvent());
  }

  Future<void> _onRequestToJoin(
    RequestToJoinGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    final result = await _requestToJoinGroupUseCase(event.params);
    result.fold(
      (failure) => emit(GroupFailure(message: failure.message)),
      (_) => emit(const GroupActionSuccess(message: 'Join request sent!')),
    );
  }
}
