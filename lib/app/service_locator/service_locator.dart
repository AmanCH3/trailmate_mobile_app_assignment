import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/data_source/remote_data_source/trail_remote_datasource.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/repository/remote_repository/trail_remote_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/domain/usecase/trail_getall_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/data_source/remote_datasource/user_remote_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/repository/remote_repository/user_remote_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_delete_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_login_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_register_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_update_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_view_model.dart';

import '../../cubit/bottom_navigation_cubit.dart';
import '../../feature/grouplist/data/data_source/group_data_source.dart';
import '../../feature/grouplist/data/data_source/remote_data_source/group_remote_data_source.dart';
import '../../feature/grouplist/data/repository/remote_repository/group_remote_repository.dart';
import '../../feature/grouplist/domain/repository/group_repository.dart';
import '../../feature/grouplist/domain/usecase/GetAll_group_usecase.dart';
import '../../feature/grouplist/domain/usecase/create_group_usecase.dart';
import '../../feature/grouplist/domain/usecase/request_to_join_usecase.dart';
import '../../feature/grouplist/presentation/view_model/group_view_model.dart';
import '../../feature/home/presentation/view_model/home_view_model.dart';
import '../../feature/splash/view_model/splash_view_model.dart';
import '../shared_pref/token_shared_prefs.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  // 1. Core Services (Network & Storage) - MUST be first
  // These have no dependencies on other parts of our app.
  await _initApiService();
  await _initSharedPrefs();

  // 2. Feature Modules that depend on Core Services
  // These modules require ApiService and/or TokenSharedPrefs to be registered.
  await _initAuthModule();
  await _initTrailModule();
  await _initGroupModule();

  // 3. ViewModels/Modules that depend on other Feature Modules
  // HomeViewModel depends on LoginViewModel, which is registered in _initAuthModule.
  await _initHomeModule();

  // 4. Other independent UI modules
  await _initSplashModule();
  await _initDashboardModules();
  ;
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

// Future _initHiveService() async {
//   serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
// }

Future _initApiService() async {
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));
}

Future<void> _initSharedPrefs() async {
  // Initialize Shared Preferences if needed
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initAuthModule() async {
  // ===================== Data Source ====================
  // serviceLocator.registerFactory(
  //   () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  // );

  serviceLocator.registerFactory(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ===================== Repository ====================

  // serviceLocator.registerFactory(
  //   () => UserLocalRepository(
  //     userLocalDataSource: serviceLocator<UserLocalDataSource>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetUseCase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserUpdateUsecase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserDeleteUsecase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // ===================== ViewModels ====================

  serviceLocator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(serviceLocator<UserRegisterUseCase>()),
  );

  // Register LoginViewModel WITHOUT HomeViewModel to avoid circular dependency
  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
  );

  serviceLocator.registerFactory(
    () => ProfileViewModel(
      userGetUseCase: serviceLocator<UserGetUseCase>(),
      userUpdateUseCase: serviceLocator<UserUpdateUsecase>(),
      userDeleteUsecase: serviceLocator<UserDeleteUsecase>(),
    ),
  );
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future<void> _initTrailModule() async {
  // serviceLocator.registerFactory(
  //   () => TrailLocalDataSource(hiveService: serviceLocator<HiveService>()),
  // );

  serviceLocator.registerFactory(
    () => TrailRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // // Repository
  // serviceLocator.registerFactory<TrailLocalRepository>(
  //   () => TrailLocalRepository(
  //     trailLocalDataSource: serviceLocator<TrailLocalDataSource>(),
  //   ),
  // );

  serviceLocator.registerFactory<TrailRemoteRepository>(
    () => TrailRemoteRepository(
      trailRemoteDataSource: serviceLocator<TrailRemoteDataSource>(),
    ),
  );

  // Usecases
  serviceLocator.registerFactory(
    () => GetAllTrailUseCase(
      trailRepository: serviceLocator<TrailRemoteRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => TrailViewModel(
      getAllTrailUseCase: serviceLocator<GetAllTrailUseCase>(),
    ),
  );
}

Future<void> _initDashboardModules() async {
  serviceLocator.registerFactory(() => BottomNavigationCubit());
}

// At the end of your service_locator.dart file, before the closing brace...

Future<void> _initGroupModule() async {
  // ===================== Data Source ====================
  // Register the remote data source, which depends on ApiService.
  serviceLocator.registerFactory<IGroupDataSource>(
    () => GroupRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ===================== Repository ====================
  // Register the repository implementation, which depends on the data source interface.
  serviceLocator.registerFactory<IGroupRepository>(
    () => GroupRepositoryImpl(
      remoteDataSource: serviceLocator<IGroupDataSource>(),
    ),
  );

  // ===================== Use Cases ====================
  // Register each use case, which depends on the repository interface.
  serviceLocator.registerFactory<GetAllGroupsUseCase>(
    () => GetAllGroupsUseCase(
      groupRepository: serviceLocator<IGroupRepository>(),
    ),
  );

  serviceLocator.registerFactory<CreateGroupUseCase>(
    () => CreateGroupUseCase(
      groupRepository: serviceLocator<IGroupRepository>(),
      tokenSharedPrefs:
          serviceLocator<TokenSharedPrefs>(), // Requires token access
    ),
  );

  serviceLocator.registerFactory<RequestToJoinGroupUseCase>(
    () => RequestToJoinGroupUseCase(
      groupRepository: serviceLocator<IGroupRepository>(),
      tokenSharedPrefs:
          serviceLocator<TokenSharedPrefs>(), // Requires token access
    ),
  );

  // You would also register GetGroupByIdUseCase here if you created it.

  // ===================== ViewModel (BLoC) ====================
  // Register the GroupViewModel, which depends on all the use cases.
  // Using registerFactory means a new instance is created every time it's requested.
  serviceLocator.registerFactory<GroupViewModel>(
    () => GroupViewModel(
      getAllGroupsUseCase: serviceLocator<GetAllGroupsUseCase>(),
      createGroupUseCase: serviceLocator<CreateGroupUseCase>(),
      requestToJoinGroupUseCase: serviceLocator<RequestToJoinGroupUseCase>(),
    ),
  );
}
