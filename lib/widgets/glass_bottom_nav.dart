import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassBottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const GlassBottomNav({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(32),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2EC4B6),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hiking),
              label: "Trails",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Saved",
            ),
          ],
        ),
      ),
    );
  }
}
