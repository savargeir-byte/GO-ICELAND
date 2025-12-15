import 'package:flutter_test/flutter_test.dart';
import 'package:go_iceland/models/place.dart';

void main() {
  group('Place Model', () {
    test('creates Place instance correctly', () {
      final place = Place(
        id: 'test-1',
        name: 'Gullfoss',
        category: 'waterfall',
        latitude: 64.3271,
        longitude: -20.1210,
        rating: 4.8,
        description: 'Golden waterfall in Iceland',
        tags: ['nature', 'famous'],
      );

      expect(place.id, equals('test-1'));
      expect(place.name, equals('Gullfoss'));
      expect(place.category, equals('waterfall'));
      expect(place.rating, equals(4.8));
      expect(place.tags, containsAll(['nature', 'famous']));
    });

    test('defaults to empty lists for optional fields', () {
      final place = Place(
        id: 'test-2',
        name: 'Test Place',
        category: 'hotel',
        latitude: 64.0,
        longitude: -20.0,
        rating: 4.0,
      );

      expect(place.tags, equals([]));
      expect(place.services, equals([]));
    });

    test('supports various categories', () {
      const categories = [
        'waterfall',
        'restaurant',
        'hotel',
        'trail',
        'activity',
        'nature',
      ];

      for (final category in categories) {
        final place = Place(
          id: 'test-$category',
          name: 'Test $category',
          category: category,
          latitude: 64.0,
          longitude: -20.0,
          rating: 4.0,
        );

        expect(place.category, equals(category));
      }
    });

    test('handles null optional fields', () {
      final place = Place(
        id: 'test-3',
        name: 'Minimal Place',
        category: 'restaurant',
        latitude: 64.0,
        longitude: -20.0,
        rating: 4.0,
      );

      expect(place.description, isNull);
      expect(place.imageUrl, isNull);
      expect(place.priceLevel, isNull);
    });
  });
}
