import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_event.dart';

class MockGetAllTrailUseCase extends Mock implements GetAllTrailUseCase {}

class FakeTrailEvent extends Fake implements TrailEvent {}
