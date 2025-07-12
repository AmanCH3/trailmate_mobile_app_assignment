import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/group_entity.dart';

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

  const CreateGroupEvent(GroupEntity tGroup1, {required this.params});

  @override
  List<Object?> get props => [params];
}

class RequestToJoinGroupEvent extends GroupEvent {
  final RequestToJoinGroupParams params;

  const RequestToJoinGroupEvent({
    required this.params,
    required String groupId,
  });

  @override
  List<Object?> get props => [params];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;

  const DeleteGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
