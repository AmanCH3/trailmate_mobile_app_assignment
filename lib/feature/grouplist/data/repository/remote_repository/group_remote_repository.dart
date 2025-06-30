import 'package:dartz/dartz.dart';
// THE FIX #1: Depend on the abstraction (the interface).
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/data_source/group_data_source.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/group_entity.dart';
import '../../../domain/repository/group_repository.dart';
import '../../../domain/usecase/create_group_usecase.dart';
import '../../../domain/usecase/request_to_join_usecase.dart';

class GroupRepositoryImpl implements IGroupRepository {
  // The dependency is now on the interface `IGroupDataSource`.
  // This decouples your repository from the remote implementation.
  final IGroupDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GroupEntity>>> getAllGroups() async {
    try {
      final result = await remoteDataSource.getAllGroups();
      print(result);
      return Right(result);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
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
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
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
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // THE FIX #2: Implements the clean, non-redundant method signature from the interface.
  @override
  Future<Either<Failure, void>> requestToJoinGroup(
    RequestToJoinGroupParams params,
    String token,
  ) async {
    try {
      // The call to the data source is simple and clean.
      await remoteDataSource.requestToJoinGroup(
        groupId: params.groupId,
        message: params.message,
        token: token,
      );
      return const Right(null);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    throw UnimplementedError(
      'getGroupById not implemented in the remote data source yet.',
    );
  }
}
