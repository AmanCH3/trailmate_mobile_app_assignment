// 1. Import necessary packages
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/group_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/group_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/GetById_group_usecase.dart';

class MockGroupRepository extends Mock implements IGroupRepository {}

void main() {
  late GetGroupByIdUseCase usecase;
  late MockGroupRepository mockGroupRepository;

  setUp(() {
    mockGroupRepository = MockGroupRepository();
    usecase = GetGroupByIdUseCase(groupRepository: mockGroupRepository);
  });

  const tGroupId = 'group-123';
  final tGroupEntity = GroupEntity(
    id: tGroupId,
    title: 'Weekend Hiking Adventure',
    description: 'A fun hike on the trail.',
    date: DateTime(2024, 9, 15),
    maxSize: 10,
    participants: [],
    status: 'open',
    meetingPointDescription: 'At the trailhead entrance',
    requirements: ['Hiking boots', 'Water bottle'],
    difficulty: 'medium',
    photos: [],
  );

  final tApiFailure = ApiFailure(statusCode: 404, message: 'Group not found');

  group('GetGroupByIdUseCase', () {
    test(
      'should get a single group entity from the repository when called with a valid ID',
      () async {
        when(
          () => mockGroupRepository.getGroupById(tGroupId),
        ).thenAnswer((_) async => Right(tGroupEntity));

        final result = await usecase(tGroupId);

        expect(result, Right(tGroupEntity));

        verify(() => mockGroupRepository.getGroupById(tGroupId)).called(1);

        verifyNoMoreInteractions(mockGroupRepository);
      },
    );

    test(
      'should return a failure when the repository fails to find a group',
      () async {
        when(
          () => mockGroupRepository.getGroupById(tGroupId),
        ).thenAnswer((_) async => Left(tApiFailure));

        final result = await usecase(tGroupId);

        expect(result, Left(tApiFailure));
        verify(() => mockGroupRepository.getGroupById(tGroupId)).called(1);
        verifyNoMoreInteractions(mockGroupRepository);
      },
    );
  });
}
