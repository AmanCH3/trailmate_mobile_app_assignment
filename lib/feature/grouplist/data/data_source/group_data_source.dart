import '../../domain/entity/group_entity.dart';
import '../../domain/usecase/create_group_usecase.dart';

abstract interface class IGroupDataSource {
  Future<List<GroupEntity>> getAllGroups();

  Future<GroupEntity> getGroupById(String groupId);

  Future<GroupEntity> createGroup(CreateGroupParams params, String token);

  Future<void> deleteGroup(String groupId, String token);

  Future<void> requestToJoinGroup({
    required String groupId,
    String? message,
    required String token,
  });
}
