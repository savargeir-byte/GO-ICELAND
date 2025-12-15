import 'package:flutter_test/flutter_test.dart';
import 'package:go_iceland/models/place.dart';

void main() {
  group('Place Model', () {
    test('creates Place instance correctly', () {
      final place = Place(
        id: 'test-1',
        name: 'Gullfoss',
        category: 'waterfall',
        lat: 64.3271,
        lng: -20.1210,
        rating: 4.8,
        description: 'Golden waterfall in Iceland',
      );

      expect(place.id, equals('test-1'));
      expect(place.name, equals('Gullfoss'));
      expect(place.category, equals('waterfall'));
      expect(place.rating, equals(4.8));
      expect(place.description, equals('Golden waterfall in Iceland'));
    });

    test('handles optional fields', () {
      final place = Place(
        id: 'test-2',
        name: 'Test Place',
        category: 'hotel',
        lat: 64.0,
        lng: -20.0,
      );

      expect(place.rating, isNull);
      expect(place.description, isNull);
      expect(place.imageUrl, isNull);
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
          lat: 64.0,
          lng: -20.0,
        );

        expect(place.category, equals(category));
      }
    });

    test('fromFirestore factory works correctly', () {
      final data = {
        'name': 'Gullfoss',
        'category': 'waterfall',
        'lat': 64.3271,
        'lng': -20.1210,
        'rating': 4.8,
        'description': 'Golden waterfall',
        'featured': true,
        'popularity': 100,
      };

      final place = Place.fromFirestore(data, 'test-id');

      expect(place.id, equals('test-id'));
      expect(place.name, equals('Gullfoss'));
      expect(place.lat, equals(64.3271));
      expect(place.featured, equals(true));
      expect(place.popularity, equals(100));
    });
  });
}
