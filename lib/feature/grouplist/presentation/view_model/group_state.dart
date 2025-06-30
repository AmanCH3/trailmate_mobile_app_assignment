import 'package:equatable/equatable.dart';

import '../../domain/entity/group_entity.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

/// The initial state, before any action has been taken.
class GroupInitial extends GroupState {}

/// State indicating that a network operation is in progress (e.g., fetching, creating).
/// The UI should show a loading indicator like a CircularProgressIndicator.
class GroupLoading extends GroupState {}

/// State representing a successful fetch of all groups.
/// The UI will use this list to build the group list view.
class GroupsLoaded extends GroupState {
  final List<GroupEntity> groups;

  const GroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

/// A generic success state for actions that don't return data (create, delete, join).
/// The UI can listen for this state to show a success message (e.g., a Snackbar).
class GroupActionSuccess extends GroupState {
  final String message;

  const GroupActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State representing any kind of failure during an operation.
/// The UI will use the message to show an error dialog or a Snackbar.
class GroupFailure extends GroupState {
  final String message;

  const GroupFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
