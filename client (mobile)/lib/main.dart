import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/app.dart';
import 'package:ump_student_grab_mobile/core/config/app_config.dart';
import 'package:ump_student_grab_mobile/core/util/location_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  AppConfig().init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  LocationManager.shared.init();

  runApp(const ProviderScope(child: App()));
}
