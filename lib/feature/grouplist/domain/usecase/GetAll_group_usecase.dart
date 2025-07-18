import 'package:dartz/dartz.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/group_entity.dart';
import '../repository/group_repository.dart';

class GetAllGroupsUseCase implements UseCaseWithoutParams<List<GroupEntity>> {
  final IGroupRepository groupRepository;

  GetAllGroupsUseCase({required this.groupRepository});

  @override
  Future<Either<Failure, List<GroupEntity>>> call() async {
    final result = await groupRepository.getAllGroups();
    return result.fold((failure) => Left(failure), (_) => result);
  }
}
