import 'package:flutter/material.dart';
import 'home_map_screen.dart';
import 'explore_screen.dart';
import 'trail_screen.dart';
import 'saved_screen.dart';
import '../widgets/glass_bottom_nav.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final screens = const [
    HomeMapScreen(),
    ExploreScreen(),
    TrailScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: GlassBottomNav(
        index: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}
