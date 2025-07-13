import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/entity/trail_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';

import 'repository_mock.dart';

void main() {
  late MockTrailRepository repository;
  late GetAllTrailUseCase usecase;

  setUp(() {
    repository = MockTrailRepository();
    usecase = GetAllTrailUseCase(trailRepository: repository);
  });

  final tTrail = TrailEnitiy(
    name: 'Test trail 1',
    location: 'Trail Location',
    duration: 00,
    elevation: 00,
    difficulty: 'test difficulty',
    images: 'Test image',
  );

  final tTrail2 = TrailEnitiy(
    name: 'Test trail 2',
    location: 'Trail Location 2 ',
    duration: 11,
    elevation: 11,
    difficulty: 'test difficulty 2 ',
    images: 'Test image 2',
  );

  final tTrails = [tTrail, tTrail2];

  test('should get trails from repository', () async {
    when(() => repository.getTrails()).thenAnswer((_) async => Right(tTrails));
    final result = await usecase();
    expect(result, Right(tTrails));

    verify(() => repository.getTrails()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
