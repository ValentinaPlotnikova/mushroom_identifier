
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/app_user.dart';
import '../models/doppelganger.dart';
import '../models/favorite.dart';
import '../models/identification.dart';
import '../models/mushroom.dart';
import '../models/mushroom_image.dart';
import '../models/mushroom_model.dart';
import '../models/user_settings.dart';
import 'firebase_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseService.instance.firestore;

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return AppUser.fromMap(doc.id, doc.data()!);
  }

  Stream<AppUser?> watchUser(String uid) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map(
          (doc) => doc.exists
          ? AppUser.fromMap(doc.id, doc.data()!)
          : null,
    );
  }

  Future<UserSettings> getSettings(String uid) async {
    final doc = await _db
        .collection(AppConstants.settingsCollection)
        .doc(uid)
        .get();

    if (!doc.exists) return const UserSettings();

    return UserSettings.fromMap(doc.data()!);
  }

  Future<void> updateSettings(
      String uid,
      UserSettings settings,
      ) async {
    await _db
        .collection(AppConstants.settingsCollection)
        .doc(uid)
        .set(
      settings.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<List<Mushroom>> getMushrooms() async {
    final snapshot = await _db
        .collection(AppConstants.mushroomsCollection)
        .get();

    return snapshot.docs
        .map(
          (doc) => Mushroom.fromMap(doc.id, doc.data()),
    )
        .toList();
  }

  Future<Mushroom?> getMushroom(String id) async {
    final doc = await _db
        .collection(AppConstants.mushroomsCollection)
        .doc(id)
        .get();

    if (!doc.exists) return null;

    return Mushroom.fromMap(doc.id, doc.data()!);
  }

  Future<List<MushroomImage>> getMushroomImages(
      String mushroomId,
      ) async {
    final snapshot = await _db
        .collection(AppConstants.mushroomImagesCollection)
        .where('mushroomId', isEqualTo: mushroomId)
        .get();

    return snapshot.docs
        .map(
          (doc) => MushroomImage.fromMap(doc.id, doc.data()),
    )
        .toList();
  }

  Future<List<Doppelganger>> getDoppelgangers(
      String mushroomId,
      ) async {
    final snapshot = await _db
        .collection(AppConstants.doppelgangersCollection)
        .where('mushroomId', isEqualTo: mushroomId)
        .get();

    return snapshot.docs
        .map(
          (doc) => Doppelganger.fromMap(doc.id, doc.data()),
    )
        .toList();
  }

  Stream<List<Mushroom>> watchMushrooms() {
    return _db
        .collection(AppConstants.mushroomsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Mushroom.fromMap(doc.id, doc.data()),
      )
          .toList(),
    );
  }

  Future<MushroomModel?> getMushroomDetail(String id) async {
    final mushroom = await getMushroom(id);

    if (mushroom == null) return null;

    final images = await getMushroomImages(id);
    final doppelgangers = await getDoppelgangers(id);

    return MushroomModel.fromMushroom(
      mushroom,
      imageUrls: images.map((image) => image.imageUrl).toList(),
      doppelgangers: doppelgangers,
    );
  }

  Stream<List<Favorite>> watchFavorites(String userId) {
    return _db
        .collection(AppConstants.favoritesCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Favorite.fromMap(doc.id, doc.data()),
      )
          .toList(),
    );
  }

  Future<void> addFavorite(
      String userId,
      String mushroomId,
      ) async {
    await _db
        .collection(AppConstants.favoritesCollection)
        .add(
      Favorite(
        id: '',
        userId: userId,
        mushroomId: mushroomId,
        addedAt: DateTime.now(),
      ).toMap(),
    );
  }

  Future<void> removeFavorite(String favoriteId) async {
    await _db
        .collection(AppConstants.favoritesCollection)
        .doc(favoriteId)
        .delete();
  }

  Stream<List<Identification>> watchIdentifications(
      String userId,
      ) {
    return _db
        .collection(AppConstants.identificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Identification.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Future<Map<String, dynamic>> buildExportPayload(
      String uid,
      ) async {
    final identsSnap = await _db
        .collection(AppConstants.identificationsCollection)
        .where('userId', isEqualTo: uid)
        .get();

    final identifications = identsSnap.docs.map((doc) {
      final identification = Identification.fromMap(
        doc.id,
        doc.data(),
      );

      return <String, dynamic>{
        'id': identification.id,
        'imageUrl': identification.imageUrl,
        'status': identification.status.value,
        'createdAt': identification.createdAt.toIso8601String(),
        'results': identification.results
            .map(
              (prediction) => {
            'mushroomId': prediction.mushroomId,
            'mushroomName': prediction.mushroomName,
            'confidence': prediction.confidence,
          },
        )
            .toList(),
      };
    }).toList()
      ..sort(
            (a, b) => (b['createdAt'] as String).compareTo(
          a['createdAt'] as String,
        ),
      );

    final favSnap = await _db
        .collection(AppConstants.favoritesCollection)
        .where('userId', isEqualTo: uid)
        .get();

    final favorites = <Map<String, dynamic>>[];

    for (final doc in favSnap.docs) {
      final favorite = Favorite.fromMap(
        doc.id,
        doc.data(),
      );

      final mushroom = await getMushroom(
        favorite.mushroomId,
      );

      favorites.add({
        'mushroomId': favorite.mushroomId,
        'mushroomName': mushroom?.nameRu ?? '',
        'nameLatin': mushroom?.nameLatin ?? '',
        'addedAt': favorite.addedAt.toIso8601String(),
      });
    }

    return {
      'exportDate': DateTime.now().toIso8601String(),
      'userId': uid,
      'identifications': identifications,
      'favorites': favorites,
    };
  }
}
