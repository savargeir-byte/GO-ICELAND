import 'dart:ui';
import 'package:flutter/material.dart';

class CrystalFilterPanel extends StatefulWidget {
  final Function(String) onCategory;
  final String? selectedCategory;
  final List<String>? customCategories;

  const CrystalFilterPanel({
    super.key,
    required this.onCategory,
    this.selectedCategory,
    this.customCategories,
  });

  @override
  State<CrystalFilterPanel> createState() => _CrystalFilterPanelState();
}

class _CrystalFilterPanelState extends State<CrystalFilterPanel> {
  String? _selected;

  static const List<String> _defaultCategories = [
    'All',
    'Waterfalls',
    'Trails',
    'Hot Springs',
    'Food',
    'Activities',
    'Beaches',
    'Glaciers',
    'Viewpoints',
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.customCategories ?? _defaultCategories;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
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
                    Icons.tune,
                    color: Color(0xFF00E5FF),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (_selected != null && _selected != 'All')
                    GestureDetector(
                      onTap: () {
                        setState(() => _selected = null);
                        widget.onCategory('');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((label) => _chip(label)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) {
    final isSelected =
        _selected == label || (_selected == null && label == 'All');
    final key = label == 'All' ? '' : label.toLowerCase().replaceAll(' ', '_');

    return GestureDetector(
      onTap: () {
        setState(() => _selected = label);
        widget.onCategory(key);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF6A5CFF)],
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_getCategoryIcon(label) != null) ...[
              Icon(
                _getCategoryIcon(label),
                size: 16,
                color: isSelected ? Colors.white : Colors.white70,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData? _getCategoryIcon(String label) {
    switch (label.toLowerCase()) {
      case 'all':
        return Icons.apps;
      case 'waterfalls':
        return Icons.water_drop;
      case 'trails':
        return Icons.terrain;
      case 'hot springs':
        return Icons.hot_tub;
      case 'food':
        return Icons.restaurant;
      case 'activities':
        return Icons.sports_kabaddi;
      case 'beaches':
        return Icons.beach_access;
      case 'glaciers':
        return Icons.ac_unit;
      case 'viewpoints':
        return Icons.landscape;
      default:
        return null;
    }
  }
}
