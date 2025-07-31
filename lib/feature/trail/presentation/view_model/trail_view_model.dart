import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_state.dart';

import '../../domain/entity/trail_entity.dart';

class TrailViewModel extends Bloc<TrailEvent, TrailState> {
  final GetAllTrailUseCase getAllTrailUseCase;

  TrailViewModel({required this.getAllTrailUseCase})
    : super(const TrailInitialState()) {
    on<LoadAllTrailsEvent>(_onLoadAllTrails);
    on<RefreshTrailsEvent>(_onRefreshTrails);
    on<SearchTrailsEvent>(_onSearchTrails);
    // on<FilterTrailsEvent>(_onFilterTrails);
  }

  Future<void> _onLoadAllTrails(
    LoadAllTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(const TrailLoadingState());
    final result = await getAllTrailUseCase();
    result.fold(
      (failure) => emit(TrailErrorState(failure.message)),
      (trails) =>
          emit(TrailLoadedState(trails: trails, filteredTrails: trails)),
    );
  }

  Future<void> _onRefreshTrails(
    RefreshTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    add(const LoadAllTrailsEvent());
  }

  void _onSearchTrails(SearchTrailsEvent event, Emitter<TrailState> emit) {
    final currentState = state;
    if (currentState is TrailLoadedState) {
      final filteredTrails = _applyFilters(
        trails: currentState.trails,
        searchTerm: event.searchTerm,
        difficult: currentState.currentDifficulty,
        maxDuration: currentState.currentMaxDuration,
        maxElevation: currentState.currentMaxElevation,
      );

      emit(
        currentState.copyWith(
          filteredTrails: filteredTrails,
          currentSearchTerm: event.searchTerm,
        ),
      );
    }
  }

  // void _onFilterTrails(FilterTrailsEvent event, Emitter<TrailState> emit) {
  //   final currentState = state;
  //   if (currentState is TrailLoadedState) {
  //     final filteredTrails = _applyFilters(
  //       trails: currentState.trails,
  //       searchTerm: currentState.currentSearchTerm,
  //       difficulty: event.difficulty,
  //       maxDuration: event.maxDuration,
  //       maxElevation: event.maxElevation,
  //     );
  //
  //     emit(
  //       currentState.copyWith(
  //         filteredTrails: filteredTrails,
  //         currentDifficulty: event.difficulty,
  //         currentMaxDuration: event.maxDuration,
  //         currentMaxElevation: event.maxElevation,
  //       ),
  //     );
  //   }
  // }

  List<TrailEnitiy> _applyFilters({
    required List<TrailEnitiy> trails,
    String searchTerm = '',
    String? difficult,
    double? maxDuration,
    double? maxElevation,
  }) {
    return trails.where((trail) {
      // Search filter
      if (searchTerm.isNotEmpty &&
          !trail.name.toLowerCase().contains(searchTerm.toLowerCase()) &&
          !trail.location.toLowerCase().contains(searchTerm.toLowerCase())) {
        return false;
      }

      // Difficulty filter
      if (difficult != null &&
          difficult != 'All' &&
          trail.difficult.toLowerCase() != difficult.toLowerCase()) {
        return false;
      }

      // Duration filter
      if (maxDuration != null && trail.duration > maxDuration) {
        return false;
      }

      // Elevation filter
      if (maxElevation != null && trail.elevation > maxElevation) {
        return false;
      }

      return true;
    }).toList();
  }
}
