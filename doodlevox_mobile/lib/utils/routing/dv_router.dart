import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doodlevox_mobile/screens/qr_scan_screen.dart';
import 'package:doodlevox_mobile/screens/record/record_screen.dart';
import 'package:doodlevox_mobile/screens/shared/dv_main_shell.dart';
import 'package:doodlevox_mobile/screens/library/library_screen.dart';
import 'package:doodlevox_mobile/screens/settings/settings_screen.dart';
import 'package:doodlevox_mobile/utils/routing/dv_cupertino_sheet_page.dart';
import 'package:doodlevox_mobile/screens/record/effects_bottom_sheet_screen.dart';

class DvRouter {
  static final rootNavKey = GlobalKey<NavigatorState>();
  static final _recordNavKey = GlobalKey<NavigatorState>();
  static final _libraryNavKey = GlobalKey<NavigatorState>();

  static final _routeLogger = Logger('DvRouter');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: '/',
    onException: (context, state, exception) {
      _routeLogger.severe('GOROUTER EXCEPTION: ${exception.toString()}');
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const QRScanScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => DVMainShell(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _recordNavKey,
            routes: [
              GoRoute(
                path: '/main/record',
                builder: (context, state) => const RecordScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _libraryNavKey,
            routes: [
              GoRoute(
                path: '/main/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
        ],
      ),

      // Effects bottom sheet route
      GoRoute(
        path: '/record/effects',
        parentNavigatorKey: rootNavKey,
        pageBuilder: (context, state) => CupertinoSheetPage<void>(
          child: const SheetScaffold(),
        ),
      ),

      // Settings Page route
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
