// feature/user/data/data_source/user_data_source.dart

import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  // CHANGED: The login methods return a string (token or success message)
  Future<String> loginUser(String email, String password);

  Future<void> registerUser(UserEntity entity);

  Future<UserEntity> getUser(String? token);

  Future<UserEntity> updateUser(UserEntity user, String? token);

  Future<void> deleteUser(String? token);

  Future<void> updateMyStats(int steps, String? token);
}
