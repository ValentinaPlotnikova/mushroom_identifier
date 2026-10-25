import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/identification.dart';
import 'status_badge.dart';

class IdentificationListItem extends StatelessWidget {
  final Identification identification;
  final VoidCallback onTap;

  const IdentificationListItem({
    super.key,
    required this.identification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final top =
        identification.results.isNotEmpty ? identification.results.first : null;

    final title = top != null && top.mushroomName.isNotEmpty
        ? top.mushroomName
        : l10n.statusNotDetermined;

    final confidence = top != null ? '${(top.confidence * 100).round()}%' : '—';

    final date = DateFormat(
      'dd.MM.yyyy HH:mm',
    ).format(identification.createdAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: _Thumbnail(
          imageUrl: identification.imageUrl,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              date,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.identificationConfidence(confidence),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            StatusBadge(
              status: identification.status,
              compact: true,
            ),
          ],
        ),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String imageUrl;

  const _Thumbnail({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 56,
        height: 56,
        child: imageUrl.isEmpty
            ? Container(
                color: const Color(0xFFEFF3EF),
                child: const Icon(
                  Icons.image,
                  color: Colors.black26,
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: const Color(0xFFEFF3EF),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: const Color(0xFFEFF3EF),
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.black26,
                  ),
                ),
              ),
      ),
    );
  }
}
