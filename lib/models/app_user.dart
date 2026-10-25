import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final DateTime createdAt;
  final int totalIdentifications;

  const AppUser({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.totalIdentifications = 0,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalIdentifications: (map['totalIdentifications'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalIdentifications': totalIdentifications,
    };
  }

  AppUser copyWith({String? email, int? totalIdentifications}) {
    return AppUser(
      uid: uid,
      email: email ?? this.email,
      createdAt: createdAt,
      totalIdentifications: totalIdentifications ?? this.totalIdentifications,
    );
  }
}
