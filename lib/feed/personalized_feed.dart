import 'dart:math';
import '../data/place_model.dart';

/// Builds a personalized feed based on:
/// - User's saved places (boost similar categories)
/// - User's location (closer = higher score)
/// - Place ratings
/// - Popularity
class PersonalizedFeed {
  /// Build personalized feed from all places
  static List<PlaceModel> build({
    required List<PlaceModel> allPlaces,
    required Set<String> savedIds,
    required double userLat,
    required double userLng,
    int limit = 30,
  }) {
    if (allPlaces.isEmpty) return [];

    // Get preferred categories from saved places
    final savedCategories = allPlaces
        .where((p) => savedIds.contains(p.id))
        .map((p) => p.category)
        .toSet();

    // Score each place
    final scored = allPlaces.map((place) {
      double score = 0;

      // 1. Distance score (closer = higher, max 30 points)
      final distance =
          _calculateDistance(userLat, userLng, place.lat, place.lng);
      score += max(0, 30 - (distance * 0.3)); // Reduce score by 0.3 per km

      // 2. Saved category boost (max 25 points)
      if (savedCategories.contains(place.category)) {
        score += 25;
      }

      // 3. Rating score (max 25 points)
      score += (place.rating) * 5; // 5 stars = 25 points

      // 4. Popularity score (max 10 points)
      if (place.popularity != null) {
        score += min(10, place.popularity! * 0.001);
      }

      // 5. Featured boost (5 points)
      if (place.featured == true) {
        score += 5;
      }

      // 6. Already saved penalty (don't show saved at top)
      if (savedIds.contains(place.id)) {
        score -= 10;
      }

      return MapEntry(place, score);
    }).toList();

    // Sort by score descending
    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.take(limit).map((e) => e.key).toList();
  }

  /// Build "Near You" feed - purely distance based
  static List<PlaceModel> nearYou({
    required List<PlaceModel> allPlaces,
    required double userLat,
    required double userLng,
    double maxDistanceKm = 50,
    int limit = 20,
  }) {
    final nearby = allPlaces
        .map((place) {
          final distance =
              _calculateDistance(userLat, userLng, place.lat, place.lng);
          return MapEntry(place, distance);
        })
        .where((e) => e.value <= maxDistanceKm)
        .toList();

    nearby.sort((a, b) => a.value.compareTo(b.value));

    return nearby.take(limit).map((e) => e.key).toList();
  }

  /// Build "Top Rated" feed
  static List<PlaceModel> topRated({
    required List<PlaceModel> allPlaces,
    String? category,
    int limit = 20,
  }) {
    var filtered = allPlaces;
    if (category != null && category.isNotEmpty) {
      filtered = allPlaces.where((p) => p.category == category).toList();
    }

    filtered.sort((a, b) => b.rating.compareTo(a.rating));
    return filtered.take(limit).toList();
  }

  /// Build "Popular" feed
  static List<PlaceModel> popular({
    required List<PlaceModel> allPlaces,
    String? category,
    int limit = 20,
  }) {
    var filtered = allPlaces;
    if (category != null && category.isNotEmpty) {
      filtered = allPlaces.where((p) => p.category == category).toList();
    }

    filtered.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
    return filtered.take(limit).toList();
  }

  /// Build "Similar to Saved" feed
  static List<PlaceModel> similarToSaved({
    required List<PlaceModel> allPlaces,
    required Set<String> savedIds,
    int limit = 20,
  }) {
    if (savedIds.isEmpty) return [];

    // Get categories of saved places
    final savedCategories = allPlaces
        .where((p) => savedIds.contains(p.id))
        .map((p) => p.category)
        .toSet();

    // Find places in same categories that aren't saved
    final similar = allPlaces
        .where((p) =>
            savedCategories.contains(p.category) && !savedIds.contains(p.id))
        .toList();

    similar.sort((a, b) => b.rating.compareTo(a.rating));
    return similar.take(limit).toList();
  }

  /// Calculate distance between two points in kilometers
  /// Using Haversine formula
  static double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371.0; // km

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}

/// Extension for easy feed building
extension PlaceListExtension on List<PlaceModel> {
  List<PlaceModel> personalized({
    required Set<String> savedIds,
    required double userLat,
    required double userLng,
    int limit = 30,
  }) {
    return PersonalizedFeed.build(
      allPlaces: this,
      savedIds: savedIds,
      userLat: userLat,
      userLng: userLng,
      limit: limit,
    );
  }

  List<PlaceModel> nearYou({
    required double userLat,
    required double userLng,
    double maxDistanceKm = 50,
    int limit = 20,
  }) {
    return PersonalizedFeed.nearYou(
      allPlaces: this,
      userLat: userLat,
      userLng: userLng,
      maxDistanceKm: maxDistanceKm,
      limit: limit,
    );
  }
}
