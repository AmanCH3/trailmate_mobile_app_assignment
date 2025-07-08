import 'package:dartz/dartz.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/data_source/remote_data_source/group_remote_data_source.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/group_entity.dart';
import '../../../domain/repository/group_repository.dart';
import '../../../domain/usecase/create_group_usecase.dart';
import '../../../domain/usecase/request_to_join_usecase.dart';

class GroupRepositoryImpl implements IGroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GroupEntity>>> getAllGroups() async {
    try {
      final result = await remoteDataSource.getAllGroups();
      return Right(result);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup(
    CreateGroupParams params,
    String token,
  ) async {
    try {
      final result = await remoteDataSource.createGroup(params, token);
      return Right(result);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(
    String groupId,
    String token,
  ) async {
    try {
      await remoteDataSource.deleteGroup(groupId, token);
      return const Right(null);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> requestToJoinGroup(
    RequestToJoinGroupParams params,
    String token,
  ) async {
    try {
      await remoteDataSource.requestToJoinGroup(
        groupId: params.groupId,
        message: params.message,
        token: token,
      );
      return const Right(null);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    try {
      final groups = await remoteDataSource.getGroupById(groupId);
      return Right(groups);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: e.statusCode));
    }
  }
}
