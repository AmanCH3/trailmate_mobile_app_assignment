import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/request_to_join_usecase.dart';

import '../../../../core/error/failure.dart';
import '../entity/group_entity.dart';
import '../usecase/create_group_usecase.dart';

abstract interface class IGroupRepository {
  Future<Either<Failure, List<GroupEntity>>> getAllGroups();

  Future<Either<Failure, GroupEntity>> getGroupById(String groupId);

  Future<Either<Failure, GroupEntity>> createGroup(
    CreateGroupParams params,
    String token,
  );

  Future<Either<Failure, void>> requestToJoinGroup(
    RequestToJoinGroupParams params,
    String token,
  );

  Future<Either<Failure, void>> deleteGroup(String groupId, String token);
}
