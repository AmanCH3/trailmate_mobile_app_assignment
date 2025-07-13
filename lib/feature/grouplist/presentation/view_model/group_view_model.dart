import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/GetAll_group_usecase.dart';
import '../../domain/usecase/create_group_usecase.dart';
import '../../domain/usecase/request_to_join_usecase.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupViewModel extends Bloc<GroupEvent, GroupState> {
  // Dependencies on all the use cases this BLoC will need.
  final GetAllGroupsUseCase _getAllGroupsUseCase;
  final CreateGroupUseCase _createGroupUseCase;
  // final DeleteGroupUseCase _deleteGroupUseCase;
  final RequestToJoinGroupUseCase _requestToJoinGroupUseCase;

  GroupViewModel({
    required GetAllGroupsUseCase getAllGroupsUseCase,
    required CreateGroupUseCase createGroupUseCase,
    // required DeleteGroupUseCase deleteGroupUseCase,
    required RequestToJoinGroupUseCase requestToJoinGroupUseCase,
  }) : _getAllGroupsUseCase = getAllGroupsUseCase,
       _createGroupUseCase = createGroupUseCase,
       // _deleteGroupUseCase = deleteGroupUseCase,
       _requestToJoinGroupUseCase = requestToJoinGroupUseCase,
       super(GroupInitial()) {
    // Register event handlers
    on<FetchAllGroupsEvent>(_onFetchAllGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    // on<DeleteGroupEvent>(_onDeleteGroup);
    on<RequestToJoinGroupEvent>(_onRequestToJoin);

    add(FetchAllGroupsEvent());
  }

  /// Handler for fetching all groups.
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

  /// Handler for creating a new group.
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

  /// Handler for requesting to join a group.
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
