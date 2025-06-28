import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';

abstract class TrailState extends Equatable {
  const TrailState();

  @override
  List<Object?> get props => [];
}

class TrailInitialState extends TrailState {
  const TrailInitialState();
}

class TrailLoadingState extends TrailState {
  const TrailLoadingState();
}

class TrailLoadedState extends TrailState {
  final List<TrailEnitiy> trails;
  final List<TrailEnitiy> filteredTrails;
  final String currentSearchTerm;
  final String? currentDifficulty;
  final double? currentMaxDuration;
  final double? currentMaxElevation;

  const TrailLoadedState({
    required this.trails,
    required this.filteredTrails,
    this.currentSearchTerm = '',
    this.currentDifficulty,
    this.currentMaxDuration,
    this.currentMaxElevation,
  });

  TrailLoadedState copyWith({
    List<TrailEnitiy>? trails,
    List<TrailEnitiy>? filteredTrails,
    String? currentSearchTerm,
    dynamic currentDifficulty,
    dynamic currentMaxDuration,
    dynamic currentMaxElevation,
  }) {
    return TrailLoadedState(
      trails: trails ?? this.trails,
      filteredTrails: filteredTrails ?? this.filteredTrails,
      currentSearchTerm: currentSearchTerm ?? this.currentSearchTerm,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      currentMaxDuration: currentMaxDuration ?? this.currentMaxDuration,
      currentMaxElevation: currentMaxElevation ?? this.currentMaxElevation,
    );
  }

  @override
  List<Object?> get props => [
    trails,
    filteredTrails,
    currentSearchTerm,
    currentDifficulty,
    currentMaxDuration,
    currentMaxElevation,
  ];
}

class TrailErrorState extends TrailState {
  final String message;

  const TrailErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
