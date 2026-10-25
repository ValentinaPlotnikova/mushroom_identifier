import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/analysis_result.dart';
import '../models/identification.dart';
import 'firebase_service.dart';

class HistoryService {
  final FirebaseFirestore _db = FirebaseService.instance.firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection(AppConstants.identificationsCollection);

  Stream<List<Identification>> watchHistory(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Identification.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<Identification?> getIdentification(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Identification.fromMap(doc.id, doc.data()!);
  }

  Future<String> saveAnalysis({
    required String userId,
    required AnalysisResult result,
  }) async {
    final predictions = result.predictions.map((p) => p.toPrediction());

    final identification = Identification(
      id: '',
      userId: userId,
      imageUrl: result.imageUrl,
      status: result.status,
      createdAt: DateTime.now(),
      results: predictions.toList(),
    );

    final docRef = _collection.doc();
    final batch = _db.batch();

    batch.set(docRef, identification.toMap());

    for (final p in result.predictions) {
      final predRef = docRef
          .collection(AppConstants.predictionsSubcollection)
          .doc();
      batch.set(predRef, {
        'mushroomId': p.mushroomId,
        'confidence': p.confidence,
        'mushroomName': p.nameRu,
      });
    }

    final userRef =
        _db.collection(AppConstants.usersCollection).doc(userId);
    batch.set(
      userRef,
      {'totalIdentifications': FieldValue.increment(1)},
      SetOptions(merge: true),
    );

    await batch.commit();
    return docRef.id;
  }

  Future<void> deleteIdentification(String id) async {
    final docRef = _collection.doc(id);
    final predictions = await docRef
        .collection(AppConstants.predictionsSubcollection)
        .get();

    final batch = _db.batch();
    for (final pred in predictions.docs) {
      batch.delete(pred.reference);
    }
    batch.delete(docRef);
    await batch.commit();
  }
}
