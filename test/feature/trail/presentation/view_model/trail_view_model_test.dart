import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart';

import 'usecase_mock.dart';

void main() {
  late GetAllTrailUseCase mockGetAllTrailUseCase;
  late TrailViewModel trailViewModel;

  // Test data
  final tTrail1 = TrailEnitiy(
    name: 'Snowy Peak Trail',
    location: 'Mountain Range',
    duration: 120,
    elevation: 500,
    difficult: 'Hard',
    image: 'Test image 1',
    distance: 00,
    description: 'A challenging trail with snowy peaks.',
  );

  final tTrail2 = TrailEnitiy(
    name: 'Sunny Valley Walk',
    location: 'Valley Region',
    duration: 60,
    elevation: 100,
    distance: 00,
    difficult: 'Easy',
    image: 'Test image 2',
    description: 'A relaxing walk through sunny valleys.',
  );

  final tTrailList = [tTrail1, tTrail2];
  const tFailure = ApiFailure(
    message: 'Could not fetch data.',
    statusCode: 500,
  );

  setUpAll(() {
    registerFallbackValue(FakeTrailEvent());
  });

  setUp(() {
    mockGetAllTrailUseCase = MockGetAllTrailUseCase();
    trailViewModel = TrailViewModel(getAllTrailUseCase: mockGetAllTrailUseCase);
  });

  tearDown(() {
    trailViewModel.close();
  });

  test('initial state should be TrailInitialState', () {
    expect(trailViewModel.state, const TrailInitialState());
  });

  group('LoadAllTrailsEvent', () {
    blocTest<TrailViewModel, TrailState>(
      'emits [Loading, Loaded] when GetAllTrailUseCase is successful',
      build: () {
        when(
          () => mockGetAllTrailUseCase.call(),
        ).thenAnswer((_) async => Right(tTrailList));
        return trailViewModel;
      },
      act: (bloc) => bloc.add(const LoadAllTrailsEvent()),
      expect:
          () => <TrailState>[
            const TrailLoadingState(),
            TrailLoadedState(trails: tTrailList, filteredTrails: tTrailList),
          ],
      verify: (_) {
        verify(() => mockGetAllTrailUseCase.call()).called(1);
      },
    );

    blocTest<TrailViewModel, TrailState>(
      'emits [Loading, Error] when GetAllTrailUseCase fails',
      build: () {
        when(
          () => mockGetAllTrailUseCase.call(),
        ).thenAnswer((_) async => const Left(tFailure));
        return trailViewModel;
      },
      act: (bloc) => bloc.add(const LoadAllTrailsEvent()),
      expect:
          () => <TrailState>[
            const TrailLoadingState(),
            TrailErrorState(tFailure.message),
          ],
      verify: (_) {
        verify(() => mockGetAllTrailUseCase.call()).called(1);
      },
    );
  });

  group('SearchTrailsEvent', () {
    // FIX: Changed event name from SearchTrailEvent to SearchTrailsEvent
    blocTest<TrailViewModel, TrailState>(
      'emits a new TrailLoadedState with filtered trails based on search term',
      seed:
          () =>
              TrailLoadedState(trails: tTrailList, filteredTrails: tTrailList),
      build: () => trailViewModel,
      act: (bloc) => bloc.add(const SearchTrailsEvent('Snowy')), // <-- FIX
      expect:
          () => <TrailState>[
            TrailLoadedState(
              trails: tTrailList,
              filteredTrails: [tTrail1], // Only tTrail1 matches "Snowy"
              currentSearchTerm: 'Snowy',
            ),
          ],
      // No need to verify use case call, as search is a pure function on state
    );

    blocTest<TrailViewModel, TrailState>(
      'emits a new TrailLoadedState with all trails when search term is empty',
      seed:
          () => TrailLoadedState(
            trails: tTrailList,
            filteredTrails: [tTrail1], // Start with an already filtered list
            currentSearchTerm: 'Snowy',
          ),
      build: () => trailViewModel,
      act: (bloc) => bloc.add(const SearchTrailsEvent('')), // <-- FIX
      expect:
          () => <TrailState>[
            TrailLoadedState(
              trails: tTrailList,
              filteredTrails: tTrailList, // Reset to all trails
              currentSearchTerm: '',
            ),
          ],
    );
  });
}
