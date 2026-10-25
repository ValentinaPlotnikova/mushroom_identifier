import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/favorite.dart';
import 'firebase_service.dart';

class FavoritesService {
  final FirebaseFirestore _db = FirebaseService.instance.firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection(AppConstants.favoritesCollection);

  Stream<List<Favorite>> watchFavorites(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Favorite.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addToFavorites(String userId, String mushroomId) async {
    final existing = await _collection
        .where('userId', isEqualTo: userId)
        .where('mushroomId', isEqualTo: mushroomId)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return;

    await _collection.add(
      Favorite(
        id: '',
        userId: userId,
        mushroomId: mushroomId,
        addedAt: DateTime.now(),
      ).toMap(),
    );
  }

  Future<void> removeFromFavorites(String userId, String mushroomId) async {
    final docs = await _collection
        .where('userId', isEqualTo: userId)
        .where('mushroomId', isEqualTo: mushroomId)
        .get();
    final batch = _db.batch();
    for (final doc in docs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> removeFavoriteById(String favoriteId) async {
    await _collection.doc(favoriteId).delete();
  }
}
