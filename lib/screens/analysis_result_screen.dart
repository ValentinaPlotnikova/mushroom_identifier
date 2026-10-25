import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/edibility_style.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_result.dart';
import '../providers/favorites_provider.dart';
import '../widgets/status_badge.dart';

class AnalysisResultScreen extends StatefulWidget {
  final AnalysisResult result;
  final File? imageFile;

  const AnalysisResultScreen({
    super.key,
    required this.result,
    this.imageFile,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.analysisSavedToHistory),
          duration: const Duration(seconds: 2),
        ),
      );

      if (widget.result.hasDeadlyHighConfidence) {
        _showDeadlyDialog();
      }
    });
  }

  Future<void> _showDeadlyDialog() async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFB71C1C),
          size: 48,
        ),
        title: Text(
          l10n.analysisDeadlyTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFB71C1C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          l10n.analysisDeadlyMessage,
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.analysisUnderstood),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final top = result.topPrediction;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisResultTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Thumbnail(
                  imageFile: widget.imageFile,
                  imageUrl: result.imageUrl,
                ),
                const SizedBox(height: 16),
                _StatusHeader(result: result),
                const SizedBox(height: 16),
                if (result.status == IdentificationStatus.notDetermined &&
                    result.predictions.isEmpty)
                  _NotDeterminedMessage(
                    message: result.message,
                  )
                else ...[
                  if (result.message.isNotEmpty) ...[
                    _NotDeterminedMessage(
                      message: result.message,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    l10n.analysisPossibleMatches,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...result.predictions.map(
                    (prediction) => _PredictionCard(
                      prediction: prediction,
                    ),
                  ),
                  if (top != null) ...[
                    const SizedBox(height: 8),
                    _FavoriteTopButton(prediction: top),
                  ],
                ],
              ],
            ),
          ),
          const _WarningBanner(),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final File? imageFile;
  final String imageUrl;

  const _Thumbnail({
    required this.imageFile,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 180,
          height: 180,
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFEFF3EF),
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                    ),
                  ),
                )
              : Container(
                  color: const Color(0xFFEFF3EF),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 64,
                  ),
                ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final AnalysisResult result;

  const _StatusHeader({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Column(
      children: [
        StatusBadge(status: result.status),
        if (result.label.isNotEmpty && !isEnglish) ...[
          const SizedBox(height: 8),
          Text(
            result.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _NotDeterminedMessage extends StatelessWidget {
  final String message;

  const _NotDeterminedMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final displayedMessage =
        message.isNotEmpty ? message : l10n.analysisReviewWarning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEF6C00),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFFEF6C00),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              displayedMessage,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF4E342E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final AnalysisPrediction prediction;

  const _PredictionCard({
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final color = EdibilityStyle.color(prediction.edibility);
    final dangerous = EdibilityStyle.isDangerous(prediction.edibility);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    final displayName = isEnglish && prediction.nameLatin.isNotEmpty
        ? prediction.nameLatin
        : prediction.nameRu;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 0.7,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/mushroom/${prediction.mushroomId}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  dangerous ? Icons.warning_amber_rounded : Icons.eco_outlined,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!isEnglish && prediction.nameLatin.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        prediction.nameLatin,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (dangerous) ...[
                            Icon(
                              Icons.warning_amber_rounded,
                              color: color,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              isEnglish
                                  ? l10n.analysisEdibilitySeeDetails
                                  : prediction.edibility.labelRu,
                              softWrap: true,
                              style: TextStyle(
                                color: theme.brightness == Brightness.dark
                                    ? theme.colorScheme.onSurface
                                    : color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${prediction.confidencePercent}%',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.analysisConfidence,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteTopButton extends StatelessWidget {
  final AnalysisPrediction prediction;

  const _FavoriteTopButton({
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<FavoritesProvider>(
      builder: (context, favorites, _) {
        final isFavorite = favorites.isFavorite(prediction.mushroomId);

        return OutlinedButton.icon(
          onPressed: () => favorites.toggleFavorite(
            prediction.mushroomId,
          ),
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          ),
          label: Text(
            isFavorite ? l10n.analysisInFavorites : l10n.analysisAddToFavorites,
          ),
        );
      },
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRussian = Localizations.localeOf(context).languageCode == 'ru';

    final warning = isRussian
        ? AppConstants.analysisWarningText
        : l10n.analysisSafetyWarning;

    return Container(
      width: double.infinity,
      color: const Color(0xFFB71C1C),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                warning,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
