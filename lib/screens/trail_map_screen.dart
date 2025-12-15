import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrailMapScreen extends StatelessWidget {
  final String trailName;
  final List<List<double>> polyline;
  final String? difficulty;

  const TrailMapScreen({
    super.key,
    required this.trailName,
    required this.polyline,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final points = polyline.map((p) => LatLng(p[0], p[1])).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(trailName),
        actions: [
          if (difficulty != null)
            Chip(
              label: Text(difficulty!),
              backgroundColor: _getDifficultyColor(difficulty!),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: points.first,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.goiceland.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    strokeWidth: 4,
                    color: Colors.orange,
                  )
                ],
              ),
              MarkerLayer(
                markers: [
                  // Start marker
                  Marker(
                    point: points.first,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.green,
                      size: 36,
                    ),
                  ),
                  // End marker
                  Marker(
                    point: points.last,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trail Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Distance: ${_calculateDistance(points).toStringAsFixed(2)} km'),
                    if (difficulty != null) Text('Difficulty: $difficulty'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
      case 'medium':
        return Colors.orange;
      case 'hard':
      case 'difficult':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double _calculateDistance(List<LatLng> points) {
    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final distance = const Distance().as(
        LengthUnit.Kilometer,
        points[i],
        points[i + 1],
      );
      total += distance;
    }
    return total;
  }
}
