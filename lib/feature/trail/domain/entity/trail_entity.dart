import 'package:equatable/equatable.dart';

class TrailEnitiy extends Equatable {
  final String? trailId;
  final String name;
  final String location;
  final double durationHours;
  final int elevationMeters;
  final String difficulty;
  final String imageUrl;

  TrailEnitiy({
    this.trailId,
    required this.name,
    required this.location,
    required this.durationHours,
    required this.elevationMeters,
    required this.difficulty,
    required this.imageUrl,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    trailId,
    name,
    location,
    durationHours,
    elevationMeters,
    difficulty,
    imageUrl,
  ];
}
