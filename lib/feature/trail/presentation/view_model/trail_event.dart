import 'package:equatable/equatable.dart';

abstract class TrailEvent extends Equatable {
  const TrailEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllTrailsEvent extends TrailEvent {
  const LoadAllTrailsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshTrailsEvent extends TrailEvent {
  const RefreshTrailsEvent();

  @override
  List<Object?> get props => [];
}

class SearchTrailsEvent extends TrailEvent {
  final String searchTerm;

  const SearchTrailsEvent(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class FilterTrailsEvent extends TrailEvent {
  final String? difficulty;
  final double? maxDuration;
  final double? maxElevation;

  const FilterTrailsEvent({
    this.difficulty,
    this.maxDuration,
    this.maxElevation,
  });

  @override
  List<Object?> get props => [difficulty, maxDuration, maxElevation];
}
