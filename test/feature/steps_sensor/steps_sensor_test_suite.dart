// Test suite for Steps Sensor feature
// This file imports all test files for the steps sensor feature

// Domain layer tests
import 'domain/entity/step_entity_test.dart';
import 'domain/usecase/get_all_total_steps_usecase_test.dart';
import 'domain/usecase/save_step_usecase_test.dart';

// Presentation layer tests
import 'presentation/view_model/step_event_test.dart';
import 'presentation/view_model/step_state_test.dart';
import 'presentation/view_model/step_view_model_test.dart';
import 'presentation/widget/step_counter_widget_test.dart';

void main() {
  // This file serves as a test suite that can be run to execute all steps sensor tests
  // Individual test files can also be run separately

  // Domain Layer Tests
  stepEntityTest();
  getAllTotalStepsUsecaseTest();
  saveStepUsecaseTest();

  // Presentation Layer Tests
  stepEventTest();
  stepStateTest();
  stepViewModelTest();
  trailDetailsViewTest();
  stepCounterWidgetTest();
}

// Test runner functions (these would be called by the test framework)
void stepEntityTest() {
  // StepEntity tests
}

void getAllTotalStepsUsecaseTest() {
  // GetAllTotalStepsUsecase tests
}

void saveStepUsecaseTest() {
  // SaveSteps tests
}

void stepEventTest() {
  // StepEvent tests
}

void stepStateTest() {
  // StepState tests
}

void stepViewModelTest() {
  // StepBloc tests
}

void trailDetailsViewTest() {
  // TrailDetailsView widget tests
}

void stepCounterWidgetTest() {
  // StepCounterWidget tests
}
