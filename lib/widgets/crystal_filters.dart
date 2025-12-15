import 'package:flutter/material.dart';
import 'glass_container.dart';

class CrystalFilters extends StatefulWidget {
  final Function(String?)? onCategoryChanged;
  final Function(double)? onDifficultyChanged;
  final Function(double)? onDistanceChanged;

  const CrystalFilters({
    super.key,
    this.onCategoryChanged,
    this.onDifficultyChanged,
    this.onDistanceChanged,
  });

  @override
  State<CrystalFilters> createState() => _CrystalFiltersState();
}

class _CrystalFiltersState extends State<CrystalFilters> {
  String? _selectedCategory;
  double _difficulty = 2;
  double _distance = 50;
  bool _expanded = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps, 'value': null},
    {'name': 'Waterfalls', 'icon': Icons.water, 'value': 'waterfall'},
    {'name': 'Trails', 'icon': Icons.hiking, 'value': 'trail'},
    {'name': 'Food', 'icon': Icons.restaurant, 'value': 'restaurant'},
    {'name': 'Hot Springs', 'icon': Icons.hot_tub, 'value': 'hot_spring'},
    {'name': 'Beaches', 'icon': Icons.beach_access, 'value': 'beach'},
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(30),
        opacity: 0.25,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle button
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.tune, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              if (_expanded) ...[
                const SizedBox(height: 16),

                // Categories
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat['value'];
                    return FilterChip(
                      avatar: Icon(
                        cat['icon'],
                        size: 18,
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : Colors.white70,
                      ),
                      label: Text(cat['name']),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedCategory = cat['value']);
                        widget.onCategoryChanged?.call(cat['value']);
                      },
                      backgroundColor: const Color(0xFF1A2744),
                      selectedColor: const Color(0xFF00E5FF).withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : Colors.white70,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF00E5FF)
                              : Colors.white24,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),

                // Distance slider
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Distance',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Spacer(),
                    Text(
                      '${_distance.round()} km',
                      style: const TextStyle(
                        color: Color(0xFF00E5FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _distance,
                  min: 5,
                  max: 200,
                  divisions: 39,
                  onChanged: (v) {
                    setState(() => _distance = v);
                    widget.onDistanceChanged?.call(v);
                  },
                ),

                // Difficulty slider
                Row(
                  children: [
                    const Icon(Icons.hiking, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Difficulty',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Spacer(),
                    Text(
                      _difficultyLabel(_difficulty),
                      style: TextStyle(
                        color: _difficultyColor(_difficulty),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _difficulty,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (v) {
                    setState(() => _difficulty = v);
                    widget.onDifficultyChanged?.call(v);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(double value) {
    if (value <= 1) return 'Any';
    if (value <= 2) return 'Easy';
    if (value <= 3) return 'Moderate';
    if (value <= 4) return 'Hard';
    return 'Expert';
  }

  Color _difficultyColor(double value) {
    if (value <= 1) return Colors.white70;
    if (value <= 2) return Colors.green;
    if (value <= 3) return Colors.orange;
    if (value <= 4) return Colors.red;
    return Colors.purple;
  }
}
