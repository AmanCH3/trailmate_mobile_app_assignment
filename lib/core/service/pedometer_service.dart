import 'dart:async';
import 'package:pedometer/pedometer.dart';


class PedometerService {
  late final Stream<int> sessionStepsStream;

  final _sessionStepsController = StreamController<int>.broadcast();

  StreamSubscription<StepCount>? _stepCountSubscription;
  int _initialSteps = 0;

  PedometerService() {
    sessionStepsStream = _sessionStepsController.stream;
  }

  void start() {
    _stepCountSubscription?.cancel(); // Cancel any existing subscription
    _initialSteps = 0;

    // Listen to the raw pedometer stream
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  void _onStepCount(StepCount event) {
    if (_initialSteps == 0) {
      // This is the first event for this session. Store the device's
      // total step count as the starting point.
      _initialSteps = event.steps;
    }

    // Calculate steps taken during this session
    final sessionSteps = event.steps - _initialSteps;

    // Add the new session step count to our stream for the ViewModel to listen to.
    _sessionStepsController.add(sessionSteps);
  }

  void _onStepCountError(error) {
    print("Pedometer Error: $error");
    _sessionStepsController.addError(
      'Pedometer is not available or permission was denied.',
    );
  }

  /// Stops listening to the pedometer.
  void stop() {
    _stepCountSubscription?.cancel();
  }

  /// Cleans up resources. Should be called when the ViewModel is disposed.
  void dispose() {
    _stepCountSubscription?.cancel();
    _sessionStepsController.close();
  }
}
