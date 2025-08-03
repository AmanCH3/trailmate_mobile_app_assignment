// import 'dart:async';

// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
// import 'package:trailmate_mobile_app_assignment/core/service/pedometer_service.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/usecase/get_all_total_steps_usecase.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/usecase/save_step_usecase.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/enum_step_status.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_event.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_state.dart';
// import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_view_model.dart';
// import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';
// import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
// import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';

// class MockGetAllTotalStepsUsecase extends Mock
//     implements GetAllTotalStepsUsecase {}

// class MockSaveSteps extends Mock implements SaveSteps {}

// class MockPedometerService extends Mock implements PedometerService {}

// class MockUserGetUseCase extends Mock implements UserGetUseCase {}

// class MockGetAllTrailUseCase extends Mock implements GetAllTrailUseCase {}

// void main() {
//   late StepBloc stepBloc;
//   late MockGetAllTotalStepsUsecase mockGetAllTotalStepsUsecase;
//   late MockSaveSteps mockSaveSteps;
//   late MockPedometerService mockPedometerService;
//   late MockUserGetUseCase mockUserGetUseCase;
//   late MockGetAllTrailUseCase mockGetAllTrailUseCase;

//   setUp(() {
//     mockGetAllTotalStepsUsecase = MockGetAllTotalStepsUsecase();
//     mockSaveSteps = MockSaveSteps();
//     mockPedometerService = MockPedometerService();
//     mockUserGetUseCase = MockUserGetUseCase();
//     mockGetAllTrailUseCase = MockGetAllTrailUseCase();

//     stepBloc = StepBloc(
//       getAllTotalStepsUsecase: mockGetAllTotalStepsUsecase,
//       saveStepsUseCase: mockSaveSteps,
//       pedometerService: mockPedometerService,
//       userGetUseCase: mockUserGetUseCase,
//       getAllTrailUseCase: mockGetAllTrailUseCase,
//     );
//   });

//   tearDown(() {
//     stepBloc.close();
//   });

//   const tUser = UserEntity(
//     userId: 'user_123',
//     name: 'Test User',
//     email: 'test@example.com',
//     phone: '',
//     password: '',
//   );

//   group('StepBloc', () {
//     test('initial state should be StepState.initial()', () {
//       expect(stepBloc.state, equals(StepState.initial()));
//     });

//     group('LoadTotalSteps', () {
//       blocTest<StepBloc, StepState>(
//         'emits [loading, success] when LoadTotalSteps is successful',
//         build: () {
//           when(
//             () => mockGetAllTotalStepsUsecase(),
//           ).thenAnswer((_) async => const Right(1500));
//           when(
//             () => mockUserGetUseCase(),
//           ).thenAnswer((_) async => const Right(tUser));

//           return stepBloc;
//         },
//         act: (bloc) => bloc.add(LoadTotalSteps()),
//         expect:
//             () => [
//               const StepState(
//                 status: StepStatus.loading,
//                 sessionSteps: 0,
//                 totalSteps: 0,
//                 errorMessage: '',
//               ),
//               const StepState(
//                 status: StepStatus.success,
//                 sessionSteps: 0,
//                 totalSteps: 1500,
//                 errorMessage: '',
//               ),
//             ],
//         verify: (_) {
//           verify(() => mockGetAllTotalStepsUsecase()).called(1);
//         },
//       );

//       blocTest<StepBloc, StepState>(
//         'emits [loading, error] when LoadTotalSteps fails',
//         build: () {
//           const failure = ApiFailure(
//             statusCode: 500,
//             message: 'Failed to fetch total steps',
//           );
//           when(
//             () => mockGetAllTotalStepsUsecase(),
//           ).thenAnswer((_) async => const Left(failure));
//           when(
//             () => mockUserGetUseCase(),
//           ).thenAnswer((_) async => const Right(tUser));
//           when(
//             () => mockUserGetUseCase(),
//           ).thenAnswer((_) async => const Right(tUser));
//           return stepBloc;
//         },
//         act: (bloc) => bloc.add(LoadTotalSteps()),
//         expect:
//             () => [
//               const StepState(
//                 status: StepStatus.loading,
//                 sessionSteps: 0,
//                 totalSteps: 0,
//                 errorMessage: '',
//               ),
//               const StepState(
//                 status: StepStatus.error,
//                 sessionSteps: 0,
//                 totalSteps: 0,
//                 errorMessage: 'Failed to fetch total steps',
//               ),
//             ],
//         verify: (_) {
//           verify(() => mockGetAllTotalStepsUsecase()).called(1);
//         },
//       );
//     });

//     group('StartStepTracking', () {
//       blocTest<StepBloc, StepState>(
//         'emits [tracking] when StartStepTracking is called',
//         build: () {
//           when(
//             () => mockUserGetUseCase(),
//           ).thenAnswer((_) async => const Right(tUser));
//           return stepBloc;
//         },
//         act: (bloc) => bloc.add(const StartStepTracking(trailId: 'trail_123')),
//         expect:
//             () => [
//               const StepState(
//                 status: StepStatus.tracking,
//                 sessionSteps: 0,
//                 totalSteps: 0,
//                 errorMessage: '',
//               ),
//             ],
//         verify: (_) {
//           verify(() => mockPedometerService.start()).called(1);
//         },
//       );

//       blocTest<StepBloc, StepState>(
//         'emits [error] when StartStepTracking fails',
//         build: () {
//           const failure = ApiFailure(
//             statusCode: 500,
//             message: 'Failed to start step tracking',
//           );
//           when(
//             () => mockUserGetUseCase(),
//           ).thenAnswer((_) async => const Right(tUser));
//           return stepBloc;
//         },
//         act: (bloc) => bloc.add(const StartStepTracking(trailId: 'trail_123')),
//         expect:
//             () => [
//               const StepState(
//                 status: StepStatus.error,
//                 sessionSteps: 0,
//                 totalSteps: 0,
//                 errorMessage: 'Failed to start step tracking',
//               ),
//             ],
//         verify: (_) {
//           verify(() => mockPedometerService.start()).called(1);
//         },
//       );

//       group('PedometerUpdated', () {
//         blocTest<StepBloc, StepState>(
//           'emits updated session steps when PedometerUpdated is called',
//           build: () {
//             when(
//               () => mockUserGetUseCase(),
//             ).thenAnswer((_) async => const Right(tUser));

//             return stepBloc;
//           },
//           act: (bloc) => bloc.add(const PedometerUpdated(500)),
//           expect:
//               () => [
//                 const StepState(
//                   status: StepStatus.idle,
//                   sessionSteps: 500,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//               ],
//         );
//       });

//       group('StopStepTracking', () {
//         blocTest<StepBloc, StepState>(
//           'emits [saving, error] when StopStepTracking fails to save',
//           build: () {
//             when(
//               () => mockUserGetUseCase(),
//             ).thenAnswer((_) async => const Right(tUser));

//             const failure = ApiFailure(
//               statusCode: 400,
//               message: 'Failed to save steps',
//             );
//             when(
//               () => mockGetAllTrailUseCase.call(),
//             ).thenAnswer((_) async => const Right([]));

//             return stepBloc;
//           },
//           act: (bloc) {
//             bloc.add(const StartStepTracking(trailId: 'trail_123'));
//             bloc.add(const PedometerUpdated(1000));
//             bloc.add(StopStepTracking());
//           },
//           expect:
//               () => [
//                 const StepState(
//                   status: StepStatus.tracking,
//                   sessionSteps: 0,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//                 const StepState(
//                   status: StepStatus.tracking,
//                   sessionSteps: 1000,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//                 const StepState(
//                   status: StepStatus.saving,
//                   sessionSteps: 1000,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//                 const StepState(
//                   status: StepStatus.error,
//                   sessionSteps: 1000,
//                   totalSteps: 0,
//                   errorMessage: 'Failed to save steps: Failed to save steps',
//                 ),
//               ],
//           verify: (_) {
//             verify(() => mockPedometerService.stop()).called(1);

//             verify(() => mockGetAllTrailUseCase.call()).called(1);
//           },
//         );

//         blocTest<StepBloc, StepState>(
//           'emits [success] when StopStepTracking with no session steps',
//           build: () {
//             when(
//               () => mockUserGetUseCase(),
//             ).thenAnswer((_) async => const Right(tUser));
//             when(
//               () => mockGetAllTrailUseCase.call(),
//             ).thenAnswer((_) async => const Right([]));
//             return stepBloc;
//           },
//           act: (bloc) => bloc.add(StopStepTracking()),
//           expect:
//               () => [
//                 const StepState(
//                   status: StepStatus.success,
//                   sessionSteps: 0,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//               ],
//           verify: (_) {
//             verify(() => mockPedometerService.stop()).called(1);
//             verify(() => mockGetAllTrailUseCase.call()).called(1);
//           },
//         );
//       });

//       group('User loading', () {
//         blocTest<StepBloc, StepState>(
//           'loads user on initialization',
//           build: () {
//             when(
//               () => mockUserGetUseCase(),
//             ).thenAnswer((_) async => const Right(tUser));
//             return stepBloc;
//           },
//           act: (bloc) => bloc.add(LoadTotalSteps()),
//           expect:
//               () => [
//                 const StepState(
//                   status: StepStatus.loading,
//                   sessionSteps: 0,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//               ],
//           verify: (_) {
//             verify(() => mockUserGetUseCase()).called(1);
//           },
//         );

//         blocTest<StepBloc, StepState>(
//           'handles user loading failure gracefully',
//           build: () {
//             const failure = ApiFailure(
//               statusCode: 401,
//               message: 'User not found',
//             );
//             when(
//               () => mockUserGetUseCase(),
//             ).thenAnswer((_) async => const Left(failure));
//             when(
//               () => mockGetAllTotalStepsUsecase(),
//             ).thenAnswer((_) async => const Right(1500));
//             return stepBloc;
//           },
//           act: (bloc) => bloc.add(LoadTotalSteps()),
//           expect:
//               () => [
//                 const StepState(
//                   status: StepStatus.loading,
//                   sessionSteps: 0,
//                   totalSteps: 0,
//                   errorMessage: '',
//                 ),
//                 const StepState(
//                   status: StepStatus.success,
//                   sessionSteps: 0,
//                   totalSteps: 1500,
//                   errorMessage: '',
//                 ),
//               ],
//           verify: (_) {
//             verify(() => mockUserGetUseCase()).called(1);
//           },
//         );
//       });
//     });
//   });
// }
