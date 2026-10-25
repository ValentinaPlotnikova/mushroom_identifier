import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/edibility_style.dart';
import '../l10n/app_localizations.dart';
import '../models/identification.dart';
import '../models/mushroom.dart';
import '../models/prediction.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../services/firestore_service.dart';
import '../services/history_service.dart';
import '../widgets/status_badge.dart';

class HistoryDetailScreen extends StatefulWidget {
  final String identificationId;

  const HistoryDetailScreen({
    super.key,
    required this.identificationId,
  });

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final HistoryService _history = HistoryService();
  late Future<Identification?> _future;

  @override
  void initState() {
    super.initState();
    _future = _history.getIdentification(widget.identificationId);
  }

  Future<void> _confirmDelete(Identification identification) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.historyDetailDeleteConfirmTitle),
        content: Text(l10n.historyDetailDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.profileCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFB3261E),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.historyDetailDeleteConfirmButton),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await context
          .read<HistoryProvider>()
          .deleteIdentification(identification.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.historyDetailDeleted),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.historyDetailDeleteFailed),
          backgroundColor: const Color(0xFFB3261E),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyDetailTitle),
      ),
      body: FutureBuilder<Identification?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(l10n.historyDetailLoadFailed),
            );
          }

          final identification = snapshot.data;

          if (identification == null) {
            return Center(
              child: Text(l10n.historyDetailNotFound),
            );
          }

          return _Body(
            identification: identification,
            onDelete: () => _confirmDelete(identification),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Identification identification;
  final VoidCallback onDelete;

  const _Body({
    required this.identification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    final Prediction? top =
        identification.results.isNotEmpty ? identification.results.first : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        Center(
          child: Container(
            width: 220,
            height: 220,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: identification.imageUrl.isEmpty
                ? const Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: green,
                  )
                : CachedNetworkImage(
                    imageUrl: identification.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: green,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: StatusBadge(
            status: identification.status,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _MetaTile(
                icon: Icons.calendar_today_outlined,
                label: l10n.historyDetailDate,
                value: dateFormat.format(identification.createdAt),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetaTile(
                icon: Icons.access_time_rounded,
                label: l10n.historyDetailTime,
                value: timeFormat.format(identification.createdAt),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          l10n.historyDetailResults,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (identification.results.isEmpty)
          _DetailCard(
            child: Text(
              l10n.historyDetailNotIdentified,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          ...identification.results.map(
            (prediction) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PredictionRow(prediction: prediction),
            ),
          ),
        const SizedBox(height: 12),
        if (top != null) ...[
          _DetailAction(
            icon: Icons.menu_book_outlined,
            title: l10n.historyDetailOpenMushroom,
            subtitle: l10n.historyDetailMushroomSubtitle,
            onTap: () => context.push(
              '/mushroom/${top.mushroomId}',
            ),
          ),
          const SizedBox(height: 12),
          _FavoriteButton(
            mushroomId: top.mushroomId,
          ),
          const SizedBox(height: 12),
        ],
        _DetailAction(
          icon: Icons.delete_outline_rounded,
          title: l10n.historyDetailDeleteAction,
          subtitle: l10n.historyDetailDeleteSubtitle,
          color: const Color(0xFFB3261E),
          isDestructive: true,
          onTap: onDelete,
        ),
        const SizedBox(height: 20),
        Text(
          l10n.historyDetailSafetyNotice,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Widget child;

  const _DetailCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: scheme.outlineVariant,
          width: 0.7,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _DetailIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _DetailIcon({
    required this.icon,
    required this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        size: size * 0.52,
        color: color,
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final theme = Theme.of(context);

    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailIcon(
            icon: icon,
            color: green,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionRow extends StatefulWidget {
  final Prediction prediction;

  const _PredictionRow({
    required this.prediction,
  });

  @override
  State<_PredictionRow> createState() => _PredictionRowState();
}

class _PredictionRowState extends State<_PredictionRow> {
  final FirestoreService _firestore = FirestoreService();
  late Future<Mushroom?> _future;

  @override
  void initState() {
    super.initState();
    _future = _firestore.getMushroom(widget.prediction.mushroomId);
  }

  @override
  void didUpdateWidget(covariant _PredictionRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.prediction.mushroomId != widget.prediction.mushroomId) {
      _future = _firestore.getMushroom(widget.prediction.mushroomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return FutureBuilder<Mushroom?>(
      future: _future,
      builder: (context, snapshot) {
        final mushroom = snapshot.data;

        final color = mushroom != null
            ? EdibilityStyle.color(mushroom.edibility)
            : const Color(0xFF2E7D32);

        final dangerous =
            mushroom != null && EdibilityStyle.isDangerous(mushroom.edibility);

        final theme = Theme.of(context);

        return _DetailCard(
          child: InkWell(
            onTap: () => context.push(
              '/mushroom/${widget.prediction.mushroomId}',
            ),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                _DetailIcon(
                  icon: dangerous
                      ? Icons.warning_amber_rounded
                      : Icons.eco_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prediction.mushroomName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (mushroom != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          isEnglish
                              ? l10n.analysisEdibilitySeeDetails
                              : mushroom.edibility.labelRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.brightness == Brightness.dark
                                ? theme.colorScheme.onSurface
                                : color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(widget.prediction.confidence * 100).round()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.brightness == Brightness.dark
                        ? theme.colorScheme.onSurface
                        : color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DetailAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = const Color(0xFF2E7D32),
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _DetailCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            _DetailIcon(
              icon: icon,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive ? color : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final String mushroomId;

  const _FavoriteButton({
    required this.mushroomId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<FavoritesProvider>(
      builder: (context, favorites, _) {
        final isFavorite = favorites.isFavorite(mushroomId);

        return _DetailAction(
          icon: isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          title: isFavorite
              ? l10n.historyDetailRemoveFavorite
              : l10n.historyDetailAddFavorite,
          subtitle: l10n.historyDetailSavedMushrooms,
          onTap: () => favorites.toggleFavorite(mushroomId),
        );
      },
    );
  }
}
