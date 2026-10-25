import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/edibility_style.dart';
import '../l10n/app_localizations.dart';
import '../models/doppelganger.dart';
import '../models/mushroom.dart';
import '../models/mushroom_model.dart';
import '../providers/favorites_provider.dart';
import '../services/firestore_service.dart';

class MushroomDetailScreen extends StatefulWidget {
  final String mushroomId;

  const MushroomDetailScreen({
    super.key,
    required this.mushroomId,
  });

  @override
  State<MushroomDetailScreen> createState() => _MushroomDetailScreenState();
}

class _MushroomDetailScreenState extends State<MushroomDetailScreen> {
  final FirestoreService _firestore = FirestoreService();
  late Future<MushroomModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _firestore.getMushroomDetail(widget.mushroomId);
  }

  @override
  void didUpdateWidget(covariant MushroomDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mushroomId != widget.mushroomId) {
      _future = _firestore.getMushroomDetail(widget.mushroomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mushroomDetailTitle),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, _) {
              final isFavorite = favorites.isFavorite(widget.mushroomId);

              return IconButton(
                tooltip: isFavorite
                    ? l10n.historyDetailRemoveFavorite
                    : l10n.historyDetailAddFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: scheme.onSurface,
                ),
                onPressed: () => favorites.toggleFavorite(
                  widget.mushroomId,
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<MushroomModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.mushroomDetailLoadError,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final mushroom = snapshot.data;

          if (mushroom == null) {
            return Center(
              child: Text(l10n.favoriteNotFound),
            );
          }

          return _DetailBody(
            mushroom: mushroom,
            firestore: _firestore,
          );
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final MushroomModel mushroom;
  final FirestoreService firestore;

  const _DetailBody({
    required this.mushroom,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final language = Localizations.localeOf(context).languageCode;

    final color = EdibilityStyle.color(mushroom.edibility);
    final dangerous = EdibilityStyle.isDangerous(
      mushroom.edibility,
    );

    final name = mushroom.localizedName(language);
    final family = mushroom.localizedFamily(language);
    final description = mushroom.localizedDescription(language);
    final season = mushroom.localizedSeason(language);
    final habitat = mushroom.localizedHabitat(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mushroom.isDeadly)
          Container(
            width: double.infinity,
            color: const Color(0xFFB71C1C),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.mushroomDetailDeadlyWarning,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      dangerous
                          ? Icons.warning_amber_rounded
                          : Icons.eco_outlined,
                      color: color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (mushroom.nameLatin.isNotEmpty &&
                            mushroom.nameLatin != name) ...[
                          const SizedBox(height: 4),
                          Text(
                            mushroom.nameLatin,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: _BigEdibilityBadge(
                  mushroom: mushroom,
                  color: color,
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(
                icon: Icons.category_outlined,
                label: l10n.mushroomDetailFamily,
                value: family.isEmpty ? '—' : family,
              ),
              const SizedBox(height: 20),
              _SectionTitle(
                title: l10n.mushroomDetailPhotos,
              ),
              const SizedBox(height: 8),
              _PhotoGallery(imageUrls: mushroom.imageUrls),
              const SizedBox(height: 20),
              _SectionTitle(
                title: l10n.mushroomDetailDescription,
              ),
              const SizedBox(height: 8),
              Text(
                description.isEmpty
                    ? l10n.mushroomDetailNoDescription
                    : description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(
                icon: Icons.calendar_month_outlined,
                label: l10n.mushroomDetailSeason,
                value: season.isEmpty ? '—' : season,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.forest_outlined,
                label: l10n.mushroomDetailHabitat,
                value: habitat.isEmpty ? '—' : habitat,
              ),
              if (mushroom.doppelgangers.isNotEmpty) ...[
                const SizedBox(height: 24),
                _SectionTitle(
                  title: l10n.mushroomDetailLookalikes,
                ),
                const SizedBox(height: 8),
                ...mushroom.doppelgangers.map(
                  (doppelganger) => _DoppelgangerCard(
                    key: ValueKey(
                      doppelganger.similarMushroomId,
                    ),
                    doppelganger: doppelganger,
                    firestore: firestore,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.historyDetailSafetyNotice,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _BigEdibilityBadge extends StatelessWidget {
  final MushroomModel mushroom;
  final Color color;

  const _BigEdibilityBadge({
    required this.mushroom,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dangerous = EdibilityStyle.isDangerous(mushroom.edibility);

    final label = mushroom.edibility.localizedLabel(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            dangerous
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            color: color,
            size: 19,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              softWrap: true,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onSurface
                    : color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF81C784)
                : const Color(0xFF1B5E20),
          ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 0),
        Icon(
          icon,
          color: const Color(0xFF2E7D32),
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoGallery extends StatelessWidget {
  final List<String> imageUrls;

  const _PhotoGallery({
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (imageUrls.isEmpty) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.mushroomDetailNoPhotos,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrls[index],
              width: 240,
              height: 180,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 240,
                color: theme.colorScheme.surfaceContainerLow,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 240,
                color: theme.colorScheme.surfaceContainerLow,
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DoppelgangerCard extends StatefulWidget {
  final Doppelganger doppelganger;
  final FirestoreService firestore;

  const _DoppelgangerCard({
    super.key,
    required this.doppelganger,
    required this.firestore,
  });

  @override
  State<_DoppelgangerCard> createState() => _DoppelgangerCardState();
}

class _DoppelgangerCardState extends State<_DoppelgangerCard> {
  late Future<Mushroom?> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.firestore.getMushroom(
      widget.doppelganger.similarMushroomId,
    );
  }

  @override
  void didUpdateWidget(covariant _DoppelgangerCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.doppelganger.similarMushroomId !=
        widget.doppelganger.similarMushroomId) {
      _future = widget.firestore.getMushroom(
        widget.doppelganger.similarMushroomId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final language = Localizations.localeOf(context).languageCode;

    return FutureBuilder<Mushroom?>(
      future: _future,
      builder: (context, snapshot) {
        final similar = snapshot.data;
        final color = similar != null
            ? EdibilityStyle.color(similar.edibility)
            : theme.colorScheme.onSurfaceVariant;

        final dangerous =
            similar != null && EdibilityStyle.isDangerous(similar.edibility);

        final name = similar == null
            ? l10n.mushroomDetailSimilarSpecies
            : similar.localizedName(language);
        final differences = widget.doppelganger.localizedDifferences(language);

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
            onTap: similar == null
                ? null
                : () => context.push('/mushroom/${similar.id}'),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          dangerous
                              ? Icons.warning_amber_rounded
                              : Icons.eco_outlined,
                          color: color,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  if (differences.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      differences,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
