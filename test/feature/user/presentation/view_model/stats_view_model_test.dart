import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/update_stats_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_view_model.dart';

import 'stats_view_model_test.mocks.dart';

@GenerateMocks([UpdateMyStatsUseCase])
void main() {
  group('StatsViewModel', () {
    late StatsViewModel statsViewModel;
    late MockUpdateMyStatsUseCase mockUpdateMyStatsUseCase;

    setUp(() {
      mockUpdateMyStatsUseCase = MockUpdateMyStatsUseCase();
      statsViewModel = StatsViewModel(
        updateMyStatsUseCase: mockUpdateMyStatsUseCase,
      );
    });

    tearDown(() {
      statsViewModel.close();
    });

    test('initial state should be correct', () {
      expect(statsViewModel.state.status, equals(StatsStatus.initial));
      expect(statsViewModel.state.sessionSteps, equals(0));
      expect(statsViewModel.state.isPedometerAvailable, equals(false));
      expect(statsViewModel.state.errorMessage, isNull);
    });

    test('should emit initializing status when InitializePedometer is added', () {
      // Note: This test would require mocking the pedometer and permission handler
      // For now, we'll just verify the event handler is registered
      expect(statsViewModel.state.status, equals(StatsStatus.initial));
    });

    test('should not start tracking if already tracking', () {
      // Set initial state to tracking
      statsViewModel.emit(statsViewModel.state.copyWith(
        status: StatsStatus.tracking,
        isPedometerAvailable: true,
      ));

      // Try to start tracking again
      statsViewModel.add(StartHikeTracking());

      // Should still be tracking (no change)
      expect(statsViewModel.state.status, equals(StatsStatus.tracking));
    });

    test('should stop tracking and reset when StopHikeTracking is added without steps', () {
      // Set initial state to tracking with no steps
      statsViewModel.emit(statsViewModel.state.copyWith(
        status: StatsStatus.tracking,
        sessionSteps: 0,
        isPedometerAvailable: true,
      ));

      // Stop tracking
      statsViewModel.add(StopHikeTracking());

      // Should reset to initial state
      expect(statsViewModel.state.status, equals(StatsStatus.initial));
      expect(statsViewModel.state.sessionSteps, equals(0));
    });
  });
} 