import 'package:equatable/equatable.dart';

class TrailEnitiy extends Equatable {
  final String? trailId;
  final String name;
  final String location;
  final double duration;
  final double? distance;
  final double elevation;
  final String difficulty;
  final String images;

  TrailEnitiy({
    this.trailId,
    required this.name,
    required this.location,
    required this.duration,
    required this.distance,
    required this.elevation,
    required this.difficulty,
    required this.images,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    trailId,
    name,
    location,
    duration,
    elevation,
    difficulty,
    images,
    distance,
  ];
}
