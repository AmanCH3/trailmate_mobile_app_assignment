import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/shared_pref/token_shared_prefs.dart'; // Add this dependency
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/group_repository.dart';

// The Params class is correct and does not need changes.
class RequestToJoinGroupParams extends Equatable {
  final String groupId;
  final String? message;

  const RequestToJoinGroupParams({required this.groupId, this.message});

  @override
  List<Object?> get props => [groupId, message];
}

// CORRECTED USE CASE
class RequestToJoinGroupUseCase
    implements UseCaseWithParams<void, RequestToJoinGroupParams> {
  final IGroupRepository groupRepository;
  final TokenSharedPrefs tokenSharedPrefs; // Add token dependency

  RequestToJoinGroupUseCase({
    required this.groupRepository,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, void>> call(RequestToJoinGroupParams params) async {
    final tokenResult = await tokenSharedPrefs.getToken();

    return tokenResult.fold(
      (failure) => Left(failure),
      (token) async => await groupRepository.requestToJoinGroup(params, token!),
    );
  }
}
