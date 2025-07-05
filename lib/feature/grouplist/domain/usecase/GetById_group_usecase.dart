import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';

import '../../../../core/error/failure.dart';
import '../entity/group_entity.dart';
import '../repository/group_repository.dart';

class GetGroupByIdUseCase implements UseCaseWithParams<GroupEntity, String> {
  final IGroupRepository groupRepository;

  GetGroupByIdUseCase({required this.groupRepository});

  @override
  Future<Either<Failure, GroupEntity>> call(String groupId) async {
    return await groupRepository.getGroupById(groupId);
  }
}
