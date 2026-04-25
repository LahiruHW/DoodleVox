import 'dart:developer' as dev;
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doodlevox_mobile/styles/dv_themes.dart';
import 'package:doodlevox_mobile/utils/dv_app_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doodlevox_mobile/utils/dv_shared_prefs.dart';
import 'package:doodlevox_mobile/utils/routing/dv_router.dart';
import 'package:doodlevox_mobile/providers/dv_daw_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:doodlevox_mobile/providers/dv_sync_provider.dart';
import 'package:doodlevox_mobile/providers/dv_prefs_provider.dart';
import 'package:doodlevox_mobile/providers/dv_audio_provider.dart';
import 'package:doodlevox_mobile/providers/dv_library_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
  log.info("Loading dependencies...");
  await Future.wait([
    DVSharedPrefs.init(),
    DVAppInfo.init(),
  ]);
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  final appRuntime = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DVPrefsProvider()),
      ChangeNotifierProvider(create: (_) => DVAudioProvider()),
      ChangeNotifierProvider(create: (_) => DVDawProvider()),
      ChangeNotifierProvider(create: (_) {
        final lib = DVLibraryProvider();
        lib.loadRecordings();
        return lib;
      }),
      ChangeNotifierProvider(create: (_) => DVSyncProvider()),
    ],
    builder: (context, child) => const DoodleVoxApp(),
  );

  log.fine("Starting the app...");
  runApp(appRuntime);
}

class DoodleVoxApp extends StatelessWidget {
  const DoodleVoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final prefsProvider = context.watch<DVPrefsProvider>();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'DoodleVox',
          theme: DVTheme.lightTheme,
          darkTheme: DVTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          themeMode: prefsProvider.themeMode,
          routerConfig: DvRouter.router,
          themeAnimationDuration: const Duration(milliseconds: 800),
          themeAnimationCurve: Curves.easeInOut,
        );
      },
    );
  }
}
