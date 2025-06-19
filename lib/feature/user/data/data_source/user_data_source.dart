import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> loginUser(String email, String password);

  Future<void> registerUser(UserEntity entity);
}
