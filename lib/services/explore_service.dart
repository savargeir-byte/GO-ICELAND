import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/place.dart';
import '../utils/distance.dart';

class ExploreService {
  final _db = FirebaseFirestore.instance;

  /// Get personalized places based on user location and preferences
  Future<List<Place>> personalized(String uid, Position userPos) async {
    // Get user's saved places to understand preferences
    final saved =
        await _db.collection('users').doc(uid).collection('saved_places').get();

    final savedIds = saved.docs.map((d) => d.id).toSet();

    // Get categories from saved places
    Set<String> preferredCategories = {};
    if (savedIds.isNotEmpty) {
      final savedPlaces = await _db
          .collection('places')
          .where(FieldPath.documentId, whereIn: savedIds.take(10).toList())
          .get();

      preferredCategories = savedPlaces.docs
          .map((d) => d.data()['category'] as String?)
          .whereType<String>()
          .toSet();
    }

    // Fetch places (limit to prevent large data transfer)
    final snap = await _db
        .collection('places')
        .orderBy('popularity', descending: true)
        .limit(200)
        .get();

    final places = snap.docs.map((d) {
      final data = d.data();
      return Place.fromFirestore(data, d.id);
    }).toList();

    // Score and sort places
    places.sort((a, b) {
      // Calculate distance
      final distA = distanceKm(
        userPos.latitude,
        userPos.longitude,
        a.lat,
        a.lng,
      );
      final distB = distanceKm(
        userPos.latitude,
        userPos.longitude,
        b.lat,
        b.lng,
      );

      // Score based on distance (closer = higher score)
      double scoreA = 100 - (distA * 0.5);
      double scoreB = 100 - (distB * 0.5);

      // Boost score for preferred categories
      if (preferredCategories.contains(a.category)) scoreA += 20;
      if (preferredCategories.contains(b.category)) scoreB += 20;

      // Boost score for high ratings
      if (a.rating != null) scoreA += (a.rating! * 5);
      if (b.rating != null) scoreB += (b.rating! * 5);

      // Boost score for popularity
      if (a.popularity != null) scoreA += (a.popularity! * 0.01);
      if (b.popularity != null) scoreB += (b.popularity! * 0.01);

      return scoreB.compareTo(scoreA);
    });

    return places.take(50).toList();
  }

  /// Get top places globally (fallback when location unavailable)
  Future<List<Place>> topPlaces({int limit = 50}) async {
    final snap = await _db
        .collection('places')
        .orderBy('popularity', descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      return Place.fromFirestore(data, d.id);
    }).toList();
  }

  /// Get places by category
  Future<List<Place>> placesByCategory(String category,
      {int limit = 50}) async {
    final snap = await _db
        .collection('places')
        .where('category', isEqualTo: category)
        .orderBy('rating', descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      return Place.fromFirestore(data, d.id);
    }).toList();
  }
}
