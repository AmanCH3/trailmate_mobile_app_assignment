import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/service_locator/service_locator.dart';
import 'core/network/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // init Hive service
  await HiveService().init();
  // Delete database
  // await HiveService().clearAll();
  runApp(App());
}
