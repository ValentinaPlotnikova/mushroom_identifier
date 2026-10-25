import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

import '../core/constants.dart';
import '../models/analysis_result.dart';
import '../models/mushroom.dart';
import 'firebase_service.dart';
import 'firestore_service.dart';

/// Функционал отсутствует из-за ухода firebase из России
class MushroomAnalysisService {
  final FirebaseStorage _storage = FirebaseService.instance.storage;
  final FirestoreService _firestore = FirestoreService();

  final Random _random = Random();

  Future<AnalysisResult> analyzeImage(File image, String uid) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = AppConstants.storagePathForIdentification(uid, timestamp);

    final ref = _storage.ref(path);
    await ref.putFile(
      image,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final imageUrl = await ref.getDownloadURL();

    return _mockAnalyze(imageUrl);
  }

  Future<AnalysisResult> _mockAnalyze(String imageUrl) async {
    final delayMs = 1000 + _random.nextInt(1000);
    await Future.delayed(Duration(milliseconds: delayMs));

    final mushrooms = await _firestore.getMushrooms();
    if (mushrooms.isEmpty) {
      return AnalysisResult(
        status: IdentificationStatus.notDetermined,
        label: '',
        message: AppConstants.messageNotDetermined,
        predictions: const [],
        imageUrl: imageUrl,
      );
    }

    final shuffled = [...mushrooms]..shuffle(_random);
    final chosen = shuffled.take(min(3, shuffled.length)).toList();

    final rawScores =
        List<double>.generate(chosen.length, (_) => _random.nextDouble());
    rawScores.sort((a, b) => b.compareTo(a));
    final total = rawScores.fold<double>(0, (s, v) => s + v);

    final topConfidence = 0.40 + _random.nextDouble() * 0.59;

    final predictions = <AnalysisPrediction>[];
    for (var i = 0; i < chosen.length; i++) {
      final Mushroom m = chosen[i];
      final double confidence;
      if (i == 0) {
        confidence = topConfidence;
      } else {
        final share = total == 0 ? 0.0 : rawScores[i] / total;
        confidence = (topConfidence * share).clamp(0.01, topConfidence - 0.01);
      }
      predictions.add(AnalysisPrediction.fromMushroom(m, confidence));
    }
    predictions.sort((a, b) => b.confidence.compareTo(a.confidence));

    final top = predictions.first.confidence;

    if (top > 0.85) {
      return AnalysisResult(
        status: IdentificationStatus.determined,
        label: AppConstants.labelHighConfidence,
        message: '',
        predictions: predictions,
        imageUrl: imageUrl,
      );
    } else if (top >= 0.60) {
      return AnalysisResult(
        status: IdentificationStatus.needsCheck,
        label: AppConstants.labelNeedsCheck,
        message: '',
        predictions: predictions,
        imageUrl: imageUrl,
      );
    } else {
      return AnalysisResult(
        status: IdentificationStatus.notDetermined,
        label: '',
        message: AppConstants.messageNotDetermined,
        predictions: predictions,
        imageUrl: imageUrl,
      );
    }
  }
}
