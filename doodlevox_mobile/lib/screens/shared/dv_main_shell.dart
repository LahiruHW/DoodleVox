import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doodlevox_mobile/widgets/dv_logo.dart';
// import 'package:doodlevox_mobile/styles/dv_bottom_nav_style.dart';

class DVMainShell extends StatelessWidget {
  const DVMainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // final bottomTheme = Theme.of(context).bottomNavigationBarTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const DVLogo(size: 40)),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        // type: bottomTheme.type ?? BottomNavigationBarType.fixed,
        // backgroundColor: bottomTheme.backgroundColor ?? colorScheme.surface,
        // selectedItemColor: bottomTheme.selectedItemColor ?? colorScheme.primary,
        // unselectedItemColor: bottomTheme.unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6),
        // selectedLabelStyle: bottomTheme.selectedLabelStyle,
        // unselectedLabelStyle: bottomTheme.unselectedLabelStyle,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_outlined),
            activeIcon: Icon(Icons.mic),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
