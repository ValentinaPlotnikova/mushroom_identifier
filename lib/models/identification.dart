import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants.dart';
import 'prediction.dart';

class Identification {
  final String id;
  final String userId;
  final String imageUrl;
  final IdentificationStatus status;
  final DateTime createdAt;

  final List<Prediction> results;

  const Identification({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    this.results = const [],
  });

  factory Identification.fromMap(String id, Map<String, dynamic> map) {
    final rawResults = (map['results'] as List<dynamic>?) ?? const [];
    return Identification(
      id: id,
      userId: map['userId'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      status: IdentificationStatus.fromValue(
        map['status'] as String? ?? 'NotDetermined',
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      results: rawResults
          .whereType<Map<String, dynamic>>()
          .map((m) => Prediction.fromMap(m['mushroomId'] as String? ?? '', m))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'results': results.map((p) => p.toMap()).toList(),
    };
  }
}
