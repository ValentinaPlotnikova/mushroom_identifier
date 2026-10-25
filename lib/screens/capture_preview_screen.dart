
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/constants.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_result.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../services/history_service.dart';
import '../services/image_processing_service.dart';
import '../services/mushroom_analysis_service.dart';
import 'analysis_result_screen.dart';

enum CaptureSource { camera, gallery }

class CapturePreviewScreen extends StatefulWidget {
  final File image;
  final CaptureSource source;

  const CapturePreviewScreen({
    super.key,
    required this.image,
    required this.source,
  });

  @override
  State<CapturePreviewScreen> createState() =>
      _CapturePreviewScreenState();
}

class _CapturePreviewScreenState extends State<CapturePreviewScreen> {
  final ImageProcessingService _processing = ImageProcessingService();
  final MushroomAnalysisService _analysis = MushroomAnalysisService();
  final HistoryService _history = HistoryService();

  bool _isAnalyzing = false;

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context)!;
    final uid = context.read<AuthProvider>().firebaseUser?.uid;

    if (uid == null) {
      _showError(l10n.previewLoginRequired);
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final processed = await _processing.process(widget.image);

      final AnalysisResult result =
      await _analysis.analyzeImage(processed, uid);

      await _history.saveAnalysis(
        userId: uid,
        result: result,
      );

      if (!mounted) return;

      context.read<HistoryProvider>().bind(uid);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AnalysisResultScreen(
            result: result,
            imageFile: processed,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isAnalyzing = false);
      _showError(l10n.previewAnalysisFailed(e.toString()));
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRussian =
        Localizations.localeOf(context).languageCode == 'ru';

    final cancelLabel = widget.source == CaptureSource.camera
        ? l10n.previewRetake
        : l10n.profileCancel;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.previewTitle),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              widget.image,
              fit: BoxFit.contain,
            ),
          ),
          const Positioned.fill(
            child: _GuideFrameOverlay(),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isRussian
                    ? AppConstants.cameraHint
                    : l10n.previewCameraHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (!_isAnalyzing)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _confirm,
                        icon: const Icon(
                          Icons.check_circle_outline,
                        ),
                        label: Text(
                          l10n.previewConfirm,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white70,
                          ),
                          backgroundColor: Colors.black54,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pop(),
                        icon: Icon(
                          widget.source == CaptureSource.camera
                              ? Icons.refresh
                              : Icons.close,
                        ),
                        label: Text(
                          cancelLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isAnalyzing) const _AnalyzingOverlay(),
        ],
      ),
    );
  }
}

class _GuideFrameOverlay extends StatelessWidget {
  const _GuideFrameOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FractionallySizedBox(
          widthFactor: 0.72,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white70,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyzingOverlay extends StatelessWidget {
  const _AnalyzingOverlay();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: AppTheme.lightGreen,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.previewAnalyzing,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
