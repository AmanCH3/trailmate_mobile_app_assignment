import 'package:equatable/equatable.dart';

import '../../domain/usecase/create_group_usecase.dart';
import '../../domain/usecase/request_to_join_usecase.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to fetch the list of all available groups.
class FetchAllGroupsEvent extends GroupEvent {}

/// Event triggered when the user submits the form to create a new group.
class CreateGroupEvent extends GroupEvent {
  // We pass the params object directly from the UI, keeping it clean.
  final CreateGroupParams params;

  const CreateGroupEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Event triggered when a user clicks the button to join a group.
class RequestToJoinGroupEvent extends GroupEvent {
  final RequestToJoinGroupParams params;

  const RequestToJoinGroupEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Event triggered to delete a group.
class DeleteGroupEvent extends GroupEvent {
  final String groupId;

  const DeleteGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
