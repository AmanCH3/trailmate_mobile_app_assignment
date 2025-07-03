import 'package:equatable/equatable.dart';

import '../../domain/usecase/create_group_usecase.dart';
import '../../domain/usecase/request_to_join_usecase.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllGroupsEvent extends GroupEvent {}

class CreateGroupEvent extends GroupEvent {
  final CreateGroupParams params;

  const CreateGroupEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class RequestToJoinGroupEvent extends GroupEvent {
  final RequestToJoinGroupParams params;

  const RequestToJoinGroupEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;

  const DeleteGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
