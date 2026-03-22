import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doodlevox_mobile/screens/qr_scan_screen.dart';

class DvRouter {
  static final rootNavKey = GlobalKey<NavigatorState>();

  static final _routeLogger = Logger('DvRouter');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: '/',
    onException: (context, state, exception) {
      _routeLogger.severe('Routing error: ${exception.toString()}');
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const QRScanScreen(
          title: 'DoodleVox Home Page',
        ),
      ),
    ],
  );
}
