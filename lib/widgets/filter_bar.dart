import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String selectedCategory;
  final double maxDistance;
  final Function(String) onCategoryChanged;
  final Function(double) onDistanceChanged;

  const FilterBar({
    super.key,
    required this.selectedCategory,
    required this.maxDistance,
    required this.onCategoryChanged,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              for (final c in [
                'all',
                'waterfall',
                'trail',
                'restaurant',
                'hot_spring',
                'beach',
                'hotel'
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_capitalize(c)),
                    selected: selectedCategory == c,
                    onSelected: (_) => onCategoryChanged(c),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 20),
              Expanded(
                child: Slider(
                  min: 5,
                  max: 200,
                  divisions: 39,
                  label: "${maxDistance.round()} km",
                  value: maxDistance,
                  onChanged: onDistanceChanged,
                ),
              ),
              Text("${maxDistance.round()} km"),
            ],
          ),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    if (text == 'all') return 'All';
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }
}
