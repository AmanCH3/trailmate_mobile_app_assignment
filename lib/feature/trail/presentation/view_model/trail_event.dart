import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_query.dart';

abstract class TrailEvent extends Equatable {
  const TrailEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadTrails extends TrailEvent {
  final TrailQuery query;

  const LoadTrails(this.query);

  @override
  // TODO: implement props
  List<Object?> get props => [query];
}

class LoadMoreTrail extends TrailEvent {}

class RefreshTrails extends TrailEvent {}

class SearchTrails extends TrailEvent {
  final String searchTerms;

  const SearchTrails(this.searchTerms);

  @override
  // TODO: implement props
  List<Object?> get props => [searchTerms];
}

class FilterTrails extends TrailEvent {
  final TrailQuery query;

  const FilterTrails(this.query);

  @override
  // TODO: implement props
  List<Object?> get props => [query];
}

class LoadTrailDetails extends TrailEvent {
  final String trailId;

  const LoadTrailDetails(this.trailId);

  @override
  // TODO: implement props
  List<Object?> get props => [trailId];
}
