// lib/core/network/local/hive_service.dart

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trailmate_mobile_app_assignment/app/constant/hive/hive_table_constant.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/data/model/trail_hive_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Register all your adapters here
    Hive.registerAdapter(UserHiveModelAdapter());
    // Don't forget to register the Trail adapter if you haven't already
    // Hive.registerAdapter(TrailHiveModelAdapter());
  }

  //   ================ user queries =============
  Future<void> addUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  // NEW: Method to update a user. It's the same as addUser/register
  // because `put` overwrites the existing entry if the key is the same.
  Future<void> updateUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
  }

  // NEW: Method to find a user by their email address.
  Future<UserHiveModel?> getUserByEmail(String email) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    // Find the first user in the box that matches the email.
    final user = box.values.where((user) => user.email == email);
    if (user.isNotEmpty) {
      return user.first;
    }
    return null; // Return null if no user is found.
  }

  Future<void> deleteUser(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  // NEW: Method to delete a user by their email address.
  Future<void> deleteUserByEmail(String email) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    // Find the user first to get their key (userId)
    final userToDelete = box.values.where((user) => user.email == email);
    if (userToDelete.isNotEmpty) {
      // Use the user's ID (which is the key) to delete them.
      await box.delete(userToDelete.first.userId);
    }
  }

  // ===Auth queries ========
  Future<void> register(UserHiveModel auth) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  //Login using username and password
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var users = box.values.where(
      (element) => element.email == email && element.password == password,
    );
    // Using .where and checking isNotEmpty is safer than .firstWhere with orElse
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // clear all data and delete database
  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.trailBox);
  }

  // get all trails
  Future<List<TrailHiveModel>> getTrail() async {
    var box = await Hive.openBox<TrailHiveModel>(HiveTableConstant.trailBox);
    final nonNullValues = box.values.whereType<TrailHiveModel>().toList();
    return nonNullValues;
  }
}
