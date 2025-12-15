import 'dart:ui';
import 'package:flutter/material.dart';

class MapLegend extends StatefulWidget {
  final VoidCallback? onToggle;

  const MapLegend({super.key, this.onToggle});

  @override
  State<MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<MapLegend> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 16,
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF050B14).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.legend_toggle,
                          color: Color(0xFF00E5FF),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Legend',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Colors.white60,
                          size: 16,
                        ),
                      ],
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(height: 12),
                      _legendItem(
                        const Color(0xFF2196F3),
                        'Waterfalls',
                        Icons.water_drop,
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        const Color(0xFF4CAF50),
                        'Nature',
                        Icons.park,
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        const Color(0xFFFF9800),
                        'Food',
                        Icons.restaurant,
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        const Color(0xFF9C27B0),
                        'Hotels',
                        Icons.hotel,
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        const Color(0xFFF44336),
                        'Trails',
                        Icons.hiking,
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        const Color(0xFF00E5FF),
                        'Activities',
                        Icons.local_activity,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// Get marker color by category
Color getCategoryColor(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('waterfall')) return const Color(0xFF2196F3);
  if (cat.contains('nature') || cat.contains('park'))
    return const Color(0xFF4CAF50);
  if (cat.contains('food') || cat.contains('restaurant'))
    return const Color(0xFFFF9800);
  if (cat.contains('hotel') || cat.contains('accommodation'))
    return const Color(0xFF9C27B0);
  if (cat.contains('trail') || cat.contains('hik'))
    return const Color(0xFFF44336);
  if (cat.contains('activity') || cat.contains('activities'))
    return const Color(0xFF00E5FF);
  if (cat.contains('beach')) return const Color(0xFFFFEB3B);
  if (cat.contains('glacier')) return const Color(0xFF00BCD4);
  if (cat.contains('hot') || cat.contains('spring'))
    return const Color(0xFFFF5722);
  return const Color(0xFF00E5FF); // Default cyan
}

/// Get category icon
IconData getCategoryIcon(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('waterfall')) return Icons.water_drop;
  if (cat.contains('nature') || cat.contains('park')) return Icons.park;
  if (cat.contains('food') || cat.contains('restaurant'))
    return Icons.restaurant;
  if (cat.contains('hotel') || cat.contains('accommodation'))
    return Icons.hotel;
  if (cat.contains('trail') || cat.contains('hik')) return Icons.hiking;
  if (cat.contains('activity') || cat.contains('activities'))
    return Icons.local_activity;
  if (cat.contains('beach')) return Icons.beach_access;
  if (cat.contains('glacier')) return Icons.ac_unit;
  if (cat.contains('hot') || cat.contains('spring')) return Icons.hot_tub;
  if (cat.contains('view')) return Icons.landscape;
  return Icons.place; // Default
}
