class TrailQuery {
  final int page;
  final int limit;
  final String search;
  final double? maxDistance;
  final double? maxElevation;
  final int? maxDuration;
  final String? difficulty;

  const TrailQuery({
    this.page = 1,
    this.limit = 10,
    this.search = '',
    this.maxDistance,
    this.maxElevation,
    this.maxDuration,
    this.difficulty,
  });

  TrailQuery copyWith({
    int? page,
    int? limit,
    String? search,
    double? maxDistance,
    double? maxElevation,
    int? maxDuration,
    String? difficulty,
  }) {
    return TrailQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      maxDistance: maxDistance ?? this.maxDistance,
      maxElevation: maxElevation ?? this.maxElevation,
      maxDuration: maxDuration ?? this.maxDuration,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
