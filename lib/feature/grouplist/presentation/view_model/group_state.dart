import 'package:equatable/equatable.dart';

import '../../domain/entity/group_entity.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<GroupEntity> groups;

  const GroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupActionSuccess extends GroupState {
  final String message;

  const GroupActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GroupFailure extends GroupState {
  final String message;

  const GroupFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
