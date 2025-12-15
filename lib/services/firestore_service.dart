import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Place>> streamPlaces() {
    return _db.collection('places').snapshots().map(
          (snap) => snap.docs
              .map((doc) => Place.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Place>> streamPlacesByCategory(String category) {
    return _db
        .collection('places')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Place.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Place>> streamTopPlaces({int limit = 50}) {
    return _db
        .collection('places')
        .orderBy('popularity', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Place.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Place>> streamFeaturedPlaces() {
    return _db
        .collection('places')
        .where('featured', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Place.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<Place?> getPlaceById(String id) async {
    final doc = await _db.collection('places').doc(id).get();
    if (!doc.exists) return null;

    return Place.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> incrementPopularity(String placeId) async {
    await _db.collection('places').doc(placeId).update({
      'popularity': FieldValue.increment(1),
    });
  }
}
