import 'dart:developer' as dev;
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/utils/dv_router.dart';
import 'package:doodlevox_mobile/styles/dv_themes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // initialize logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    dev.log(
      '${record.level.name}: ${record.message}',
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
  final log = Logger('Main');

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // initialize any necessary services here (e.g., database, API clients, etc.)
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  log.fine("Starting the app...");
  runApp(const DoodleVoxApp());
}

class DoodleVoxApp extends StatelessWidget {
  const DoodleVoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DoodleVox',
      theme: DVTheme.lightTheme,
      darkTheme: DVTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      routerConfig: DvRouter.router,
    );
  }
}


