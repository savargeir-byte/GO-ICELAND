import 'package:flutter/material.dart';

class TrailScreen extends StatelessWidget {
  const TrailScreen({super.key});

  Color diffColor(String d) {
    switch (d) {
      case "Easy":
        return Colors.green;
      case "Moderate":
        return Colors.orange;
      case "Hard":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trails")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text("Glymur"),
            subtitle: const Text("7 km • 3–4h"),
            trailing: Chip(
              label: const Text("Moderate"),
              backgroundColor: diffColor("Moderate"),
            ),
          ),
        ],
      ),
    );
  }
}
