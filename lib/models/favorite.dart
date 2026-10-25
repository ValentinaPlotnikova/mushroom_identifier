import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String userId;
  final String mushroomId;
  final DateTime addedAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.mushroomId,
    required this.addedAt,
  });

  factory Favorite.fromMap(String id, Map<String, dynamic> map) {
    return Favorite(
      id: id,
      userId: map['userId'] as String? ?? '',
      mushroomId: map['mushroomId'] as String? ?? '',
      addedAt: (map['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mushroomId': mushroomId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
