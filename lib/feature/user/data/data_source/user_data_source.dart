import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> createUser(UserEntity entity);

  Future<List<UserEntity>> getAllUser();

  Future<void> deleteUser(String id);
}
