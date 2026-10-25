import '../core/constants.dart';
import 'mushroom.dart';
import 'prediction.dart';

class AnalysisPrediction {
  final String mushroomId;
  final String nameRu;
  final String nameLatin;
  final double confidence;
  final Edibility edibility;

  const AnalysisPrediction({
    required this.mushroomId,
    required this.nameRu,
    required this.nameLatin,
    required this.confidence,
    required this.edibility,
  });

  int get confidencePercent => (confidence * 100).round();

  factory AnalysisPrediction.fromMushroom(Mushroom m, double confidence) {
    return AnalysisPrediction(
      mushroomId: m.id,
      nameRu: m.nameRu,
      nameLatin: m.nameLatin,
      confidence: confidence,
      edibility: m.edibility,
    );
  }

  Prediction toPrediction() {
    return Prediction(
      id: mushroomId,
      mushroomId: mushroomId,
      confidence: confidence,
      mushroomName: nameRu,
    );
  }
}

class AnalysisResult {
  final IdentificationStatus status;
  final String label;
  final String message;
  final List<AnalysisPrediction> predictions;
  final String imageUrl;

  const AnalysisResult({
    required this.status,
    required this.label,
    required this.message,
    required this.predictions,
    required this.imageUrl,
  });
  AnalysisPrediction? get topPrediction =>
      predictions.isEmpty ? null : predictions.first;
  bool get hasDeadlyHighConfidence {
    final top = topPrediction;
    if (top == null) return false;
    return top.edibility == Edibility.deadlyPoisonous &&
        top.confidence > 0.85;
  }
}
