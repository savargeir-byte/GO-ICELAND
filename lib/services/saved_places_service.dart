import 'package:cloud_firestore/cloud_firestore.dart';

class SavedPlacesService {
  final _db = FirebaseFirestore.instance;

  Future<void> toggleSaved(String uid, String placeId, bool save) async {
    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('saved_places')
        .doc(placeId);

    if (save) {
      await ref.set({
        'saved': true,
        'savedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.delete();
    }
  }

  Stream<bool> isSaved(String uid, String placeId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('saved_places')
        .doc(placeId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<List<String>> getSavedPlaceIds(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('saved_places')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<List<String>> getSavedPlaceIdsList(String uid) async {
    final snapshot =
        await _db.collection('users').doc(uid).collection('saved_places').get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
