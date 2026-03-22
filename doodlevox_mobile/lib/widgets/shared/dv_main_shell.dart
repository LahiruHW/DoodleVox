import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doodlevox_mobile/widgets/dv_logo.dart';
import 'package:doodlevox_mobile/styles/dv_appbar_style.dart';
import 'package:doodlevox_mobile/styles/dv_bottom_nav_style.dart';

class DVMainShell extends StatelessWidget {
  const DVMainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final appBarStyle = Theme.of(context).extension<DVAppBarStyle>()!;
    final bottomNavStyle = Theme.of(context).extension<DVBottomNavStyle>()!;

    return Scaffold(
      appBar: AppBar(
        title: const DVLogo(size: 40),
        backgroundColor: appBarStyle.backgroundColor,
        foregroundColor: appBarStyle.foregroundColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // Library tab (index 1) is disabled
          if (index == 1) return;
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: bottomNavStyle.backgroundColor,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        indicatorColor: bottomNavStyle.selectedItemColor.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.mic_outlined, color: bottomNavStyle.unselectedItemColor),
            selectedIcon: Icon(Icons.mic, color: bottomNavStyle.selectedItemColor),
            label: 'Record',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined, color: bottomNavStyle.unselectedItemColor.withValues(alpha: 0.4)),
            selectedIcon: Icon(Icons.library_music, color: bottomNavStyle.selectedItemColor),
            label: 'Library',
            enabled: false,
          ),
        ],
      ),
    );
  }
}
