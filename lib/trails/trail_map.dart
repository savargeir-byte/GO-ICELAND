import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'trail_model.dart';
import '../widgets/glass_container.dart';

class TrailMap extends StatelessWidget {
  final Trail trail;
  final bool showControls;

  const TrailMap({
    super.key,
    required this.trail,
    this.showControls = true,
  });

  Color get diffColor {
    switch (trail.difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50); // Green
      case 'medium':
        return const Color(0xFFFF9800); // Orange
      case 'hard':
        return const Color(0xFFF44336); // Red
      case 'expert':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF00E5FF); // Cyan
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trail.polyline.isEmpty) {
      return const Center(
        child: Text(
          'No trail data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final points = trail.polyline.map((p) => LatLng(p[0], p[1])).toList();

    // Calculate bounds for the trail
    final bounds = LatLngBounds.fromPoints(points);

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: bounds.center,
            initialZoom: 13,
            initialCameraFit: CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(50),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'go.iceland.app',
            ),
            // Trail polyline with glow effect
            PolylineLayer(
              polylines: [
                // Glow layer
                Polyline(
                  points: points,
                  strokeWidth: 12,
                  color: diffColor.withOpacity(0.3),
                ),
                // Main trail line
                Polyline(
                  points: points,
                  strokeWidth: 5,
                  color: diffColor,
                ),
              ],
            ),
            // Start and end markers
            MarkerLayer(
              markers: [
                // Start marker
                Marker(
                  point: points.first,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // End marker
                Marker(
                  point: points.last,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF44336),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Trail info overlay
        if (showControls)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: GlassContainer(
                borderRadius: BorderRadius.circular(16),
                opacity: 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Difficulty badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: diffColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: diffColor),
                        ),
                        child: Text(
                          trail.difficulty.toUpperCase(),
                          style: TextStyle(
                            color: diffColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Distance
                      const Icon(Icons.straighten, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${trail.lengthKm.toStringAsFixed(1)} km',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      // Elevation gain
                      const Icon(Icons.trending_up, color: Colors.green, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${trail.elevationGain.toStringAsFixed(0)}m',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
