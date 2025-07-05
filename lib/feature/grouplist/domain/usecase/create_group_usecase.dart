import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';

import '../../../../app/shared_pref/token_shared_prefs.dart';
import '../../../../core/error/failure.dart';
import '../entity/group_entity.dart';
import '../repository/group_repository.dart';

/// Parameters required to create a new group.
/// This class encapsulates all the data needed for the use case.
class CreateGroupParams extends Equatable {
  final String title;
  final String trailId;
  final DateTime date;
  final String description;
  final int maxSize;
  final List<String> photoPaths; // List of local file paths for images

  const CreateGroupParams({
    required this.title,
    required this.trailId,
    required this.date,
    required this.description,
    required this.maxSize,
    required this.photoPaths,
  });

  @override
  List<Object?> get props => [
    title,
    trailId,
    date,
    description,
    maxSize,
    photoPaths,
  ];
}

class CreateGroupUseCase implements UseCaseWithParams<void, CreateGroupParams> {
  final IGroupRepository groupRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  CreateGroupUseCase({
    required this.groupRepository,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, GroupEntity>> call(CreateGroupParams params) async {
    // First, retrieve the authentication token
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      // If token fetching fails, return that failure
      (token) async => await groupRepository.createGroup(
        params,
        token!,
      ), // If successful, call the repository
    );
  }
}
