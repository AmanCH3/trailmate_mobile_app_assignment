import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trailmate_mobile_app_assignment/app/constant/hive/hive_table_constant.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/model/trail_hive_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(UserHiveModelAdapter());
  }

  //   ================ user queries =============
  Future<void> addUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
  }

  Future<void> deleteUser(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  // ===Auth queries ========
  Future<void> register(UserHiveModel auth) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  //Login using username and password
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
      (element) => element.email == email && element.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );
    box.close();
    return user;
  }

  // clear all data and delete database
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // get all trils
  Future<List<TrailHiveModel?>> getTrail() async {
    var box = await Hive.openBox<TrailHiveModel>(HiveTableConstant.trailBox);
    // where type filters out the not null values
    final nonNullValues = box.values.whereType<TrailHiveModel>().toList();
    return nonNullValues;
  }
}
