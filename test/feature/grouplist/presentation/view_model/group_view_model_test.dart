import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/group_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/GetAll_group_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/create_group_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/request_to_join_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';

class MockCreateGroupUseCase extends Mock implements CreateGroupUseCase {}

class MockGetAllGroupUseCase extends Mock implements GetAllGroupsUseCase {}

class MockRequestToJoinGroupUseCase extends Mock
    implements RequestToJoinGroupUseCase {}

late GroupViewModel groupViewModel;

void main() {
  late GetAllGroupsUseCase mockGetAllGroupsUseCase;
  late CreateGroupUseCase mockCreateGroupUseCase;
  late RequestToJoinGroupUseCase mockRequestToJoinGroupUseCase;
  late GroupViewModel groupViewModel;

  // --- DUMMY DATA SETUP ---
  final tGroup1 = GroupEntity(
    id: 'group-1',
    title: 'Test Group',
    date: DateTime.now(),
    description: '',
    maxSize: 10,
    participants: [],
    status: 'upcoming',
    meetingPointDescription: '',
    requirements: [],
    difficulty: 'Easy',
    photos: [],
    comments: [],
  );

  final tGroupList = [tGroup1];
  final tCreateParams = CreateGroupParams(
    title: '',
    trailId: '',
    date: DateTime.timestamp(),
    description: '',
    maxSize: 10,
    photoPaths: [],
  );
  final tRequestParams = RequestToJoinGroupParams(groupId: tGroup1.id);
  const tFailure = ApiFailure(message: 'An error occurred', statusCode: null);
  // --- END DUMMY DATA ---

  setUpAll(() {
    // Register fallback values for custom types used with `any()`
    registerFallbackValue(tCreateParams);
    registerFallbackValue(tRequestParams);
  });

  setUp(() {
    mockGetAllGroupsUseCase = MockGetAllGroupUseCase();
    mockCreateGroupUseCase = MockCreateGroupUseCase();
    mockRequestToJoinGroupUseCase = MockRequestToJoinGroupUseCase();
  });

  group('Initial State & Auto-Fetch', () {
    // This test verifies the automatic fetch that happens when the BLoC is created.
    blocTest<GroupViewModel, GroupState>(
      'emits [Loading, Loaded] when created and fetch is successful',
      setUp: () {
        // Arrange: Mock the use case that will be called by the constructor
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => Right(tGroupList));
      },
      // Build the BLoC *after* the mock is set up.
      build:
          () => GroupViewModel(
            getAllGroupsUseCase: mockGetAllGroupsUseCase,
            createGroupUseCase: mockCreateGroupUseCase,
            requestToJoinGroupUseCase: mockRequestToJoinGroupUseCase,
          ),
      // The `act` block is empty because the action happens in the constructor.
      act: (bloc) {},
      expect:
          () => <GroupState>[GroupLoading(), GroupsLoaded(groups: tGroupList)],
      verify: (_) {
        verify(() => mockGetAllGroupsUseCase.call()).called(1);
      },
    );
  });

  group('FetchAllGroupsEvent', () {
    // This tests the manual dispatch of the fetch event.
    blocTest<GroupViewModel, GroupState>(
      'emits [Loading, Loaded] on successful fetch',
      build: () {
        // Since the constructor auto-fetches, we mock it to succeed initially.
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => const Right([]));
        return GroupViewModel(
          getAllGroupsUseCase: mockGetAllGroupsUseCase,
          createGroupUseCase: mockCreateGroupUseCase,
          requestToJoinGroupUseCase: mockRequestToJoinGroupUseCase,
        );
      },
      // Now mock the response for the *second* fetch, which we trigger in `act`.
      act: (bloc) {
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => Right(tGroupList));
        bloc.add(FetchAllGroupsEvent());
      },
      // We skip the initial state emissions from the constructor.
      skip: 2,
      expect:
          () => <GroupState>[GroupLoading(), GroupsLoaded(groups: tGroupList)],
    );
  });

  group('RequestToJoinGroupEvent', () {
    blocTest<GroupViewModel, GroupState>(
      'emits [GroupActionSuccess] on successful request without re-fetching',
      build: () {
        // Mock the initial auto-fetch
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => const Right([]));
        return GroupViewModel(
          getAllGroupsUseCase: mockGetAllGroupsUseCase,
          createGroupUseCase: mockCreateGroupUseCase,
          requestToJoinGroupUseCase: mockRequestToJoinGroupUseCase,
        );
      },
      act: (bloc) {
        when(
          () => mockRequestToJoinGroupUseCase(any()),
        ).thenAnswer((_) async => const Right(true));
        bloc.add(
          RequestToJoinGroupEvent(params: tRequestParams, groupId: tGroup1.id),
        );
      },
      skip: 2,
      // Note: This event does NOT emit a loading state in your BLoC.
      expect:
          () => <GroupState>[
            const GroupActionSuccess(message: 'Join request sent!'),
          ],
      verify: (_) {
        verify(() => mockRequestToJoinGroupUseCase(tRequestParams)).called(1);
      },
    );
  });
}
