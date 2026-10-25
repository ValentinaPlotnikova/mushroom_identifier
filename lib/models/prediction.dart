class Prediction {
  final String id;
  final String mushroomId;
  final double confidence;
  final String mushroomName;

  const Prediction({
    required this.id,
    required this.mushroomId,
    required this.confidence,
    required this.mushroomName,
  });

  factory Prediction.fromMap(String id, Map<String, dynamic> map) {
    return Prediction(
      id: id,
      mushroomId: map['mushroomId'] as String? ?? '',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      mushroomName: map['mushroomName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mushroomId': mushroomId,
      'confidence': confidence,
      'mushroomName': mushroomName,
    };
  }
}
