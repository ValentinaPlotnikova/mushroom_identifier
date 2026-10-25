import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/edibility_style.dart';
import '../models/mushroom.dart';

class MushroomListItem extends StatelessWidget {
  final Mushroom mushroom;
  final VoidCallback onTap;

  const MushroomListItem({
    super.key,
    required this.mushroom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = EdibilityStyle.color(mushroom.edibility);
    final dangerous = EdibilityStyle.isDangerous(mushroom.edibility);
    final theme = Theme.of(context);

    final language = Localizations.localeOf(context).languageCode;
    final mushroomName = mushroom.localizedName(language);
    final latinName = mushroom.nameLatin.trim();

    return Card(
      margin: EdgeInsets.zero,
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      dangerous
                          ? Icons.warning_amber_rounded
                          : Icons.eco_outlined,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mushroomName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                        if (latinName.isNotEmpty &&
                            latinName != mushroomName) ...[
                          const SizedBox(height: 4),
                          Text(
                            latinName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _EdibilityChip(
                edibility: mushroom.edibility,
                color: color,
                dangerous: dangerous,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EdibilityChip extends StatelessWidget {
  final Edibility edibility;
  final Color color;
  final bool dangerous;

  const _EdibilityChip({
    required this.edibility,
    required this.color,
    required this.dangerous,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
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
            size: 17,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              edibility.localizedLabel(context),
              softWrap: true,
              style: TextStyle(
                color: color,
                fontSize: 13,
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
