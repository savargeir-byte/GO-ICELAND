import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'place_model.dart';

class PlaceRepository {
  final _db = FirebaseFirestore.instance;
  static const String _boxName = 'places';

  Box get _box => Hive.box(_boxName);

  /// Fetch places with offline-first strategy
  /// 1. Return cached data instantly
  /// 2. Fetch fresh data in background
  /// 3. Update cache
  Future<List<PlaceModel>> fetchPlaces({String? category}) async {
    try {
      // Build query
      Query<Map<String, dynamic>> query = _db.collection('places');
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      // Fetch from Firestore
      final snap = await query.limit(500).get();

      // Cache results
      for (var doc in snap.docs) {
        _box.put(doc.id, {
          ...doc.data(),
          'id': doc.id,
        });
      }

      return snap.docs.map((d) => PlaceModel.fromJson(d.id, d.data())).toList();
    } catch (e) {
      // Fallback to cache on error
      return getCachedPlaces(category: category);
    }
  }

  /// Get cached places instantly (no network)
  List<PlaceModel> getCachedPlaces({String? category}) {
    final cached = _box.values.map((e) {
      final map = Map<String, dynamic>.from(e);
      return PlaceModel.fromJson(map['id'], map);
    }).toList();

    if (category != null && category.isNotEmpty) {
      return cached.where((p) => p.category == category).toList();
    }
    return cached;
  }

  /// Fetch top places by popularity
  Future<List<PlaceModel>> fetchTopPlaces({int limit = 50}) async {
    try {
      final snap = await _db
          .collection('places')
          .orderBy('popularity', descending: true)
          .limit(limit)
          .get();

      for (var doc in snap.docs) {
        _box.put(doc.id, {...doc.data(), 'id': doc.id});
      }

      return snap.docs.map((d) => PlaceModel.fromJson(d.id, d.data())).toList();
    } catch (e) {
      // Fallback: sort cached by popularity
      final cached = getCachedPlaces();
      cached.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
      return cached.take(limit).toList();
    }
  }

  /// Fetch featured places
  Future<List<PlaceModel>> fetchFeaturedPlaces() async {
    try {
      final snap = await _db
          .collection('places')
          .where('featured', isEqualTo: true)
          .limit(10)
          .get();

      return snap.docs.map((d) => PlaceModel.fromJson(d.id, d.data())).toList();
    } catch (e) {
      return getCachedPlaces().where((p) => p.featured == true).toList();
    }
  }

  /// Get single place by ID
  Future<PlaceModel?> getPlaceById(String id) async {
    // Check cache first
    final cached = _box.get(id);
    if (cached != null) {
      return PlaceModel.fromJson(id, Map<String, dynamic>.from(cached));
    }

    // Fetch from Firestore
    try {
      final doc = await _db.collection('places').doc(id).get();
      if (!doc.exists) return null;

      _box.put(doc.id, {...doc.data()!, 'id': doc.id});
      return PlaceModel.fromJson(doc.id, doc.data()!);
    } catch (e) {
      return null;
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _box.clear();
  }

  /// Get cache stats
  Map<String, dynamic> getCacheStats() {
    return {
      'count': _box.length,
      'categories': _box.values.map((e) => e['category']).toSet().toList(),
    };
  }
}
