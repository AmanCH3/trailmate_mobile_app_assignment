import 'package:get_it/get_it.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/remote_datasource/user_remote_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/repository/local_repository/user_local_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/repository/remote_repository/user_remote_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_login_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_register_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_view_model.dart';

import '../../core/network/local/hive_service.dart';
import '../../feature/splash/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSplashModule();
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initAuthModule() async {
  // ===================== Data Source ====================
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ===================== Repository ====================

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDataSource: serviceLocator<UserLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  // ===================== Usecases ====================

  // serviceLocator.registerFactory(
  //       () => UserLoginUseCase(
  //     userRepository: serviceLocator<UserRemoteRepository>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    () => UserRegisterUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  // serviceLocator.registerFactory(
  //       () => StudentGetCurrentUsecase(
  //     studentRepository: serviceLocator<StudentRemoteRepository>(),
  //   ),
  // );

  // ===================== ViewModels ====================

  serviceLocator.registerFactory(
    () => RegisterViewModel(serviceLocator<UserRegisterUseCase>()),
  );

  // Register LoginViewModel WITHOUT HomeViewModel to avoid circular dependency
  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
  );
}

//
// Future _initUserModule() async {
//   //Data Source
//   serviceLocator.registerFactory(
//     () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
//   );
//
//   // Repository
//   serviceLocator.registerLazySingleton<UserRemoteRepository>(
//     () => UserRemoteRepository(
//       userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
//     ),
//   );
//
//   // usecase
//   serviceLocator.registerFactory(
//     () => UserRegisterUseCase(
//       userRepository: serviceLocator<UserRemoteRepository>(),
//     ),
//   );
// }
