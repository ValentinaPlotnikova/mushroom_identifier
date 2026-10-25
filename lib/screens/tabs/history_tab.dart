import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/identification.dart';
import '../../providers/history_provider.dart';
import '../../widgets/identification_list_item.dart';
import '../../widgets/status_badge.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.identificationHistory),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: TextField(
              controller: _searchController,
              onChanged: history.searchHistory,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchMushroomsHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: history.query.isNotEmpty
                    ? IconButton(
                        tooltip: l10n.clearSearch,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          history.searchHistory('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          _StatusFilterBar(
            selected: history.statusFilter,
            onSelected: history.filterByStatus,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildBody(context, history),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    HistoryProvider history,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (history.isLoading && history.all.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (history.all.isEmpty) {
      return const _EmptyHistory();
    }

    final items = history.filtered;

    if (items.isEmpty) {
      return _HistoryMessage(
        icon: Icons.search_off_rounded,
        title: l10n.noResultsFound,
        subtitle: l10n.changeSearchOrFilter,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final Identification item = items[index];

        return IdentificationListItem(
          identification: item,
          onTap: () => context.push('/history/${item.id}'),
        );
      },
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  final IdentificationStatus? selected;
  final ValueChanged<IdentificationStatus?> onSelected;

  const _StatusFilterBar({
    required this.selected,
    required this.onSelected,
  });

  String _statusLabel(
    IdentificationStatus status,
    AppLocalizations l10n,
  ) {
    switch (status.name) {
      case 'determined':
        return l10n.statusDetermined;
      case 'needsCheck':
        return l10n.statusNeedsCheck;
      case 'notDetermined':
        return l10n.statusNotDetermined;
      default:
        return status.labelRu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(
            context,
            label: l10n.all,
            value: null,
          ),
          ...IdentificationStatus.values.map(
            (status) => _chip(
              context,
              label: _statusLabel(status, l10n),
              value: status,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required IdentificationStatus? value,
  }) {
    const green = Color(0xFF2E7D32);

    final selectedColor = value == null ? green : StatusBadge.colorFor(value);

    final isSelected = selected == value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        selectedColor: selectedColor.withValues(
          alpha: isDark ? 0.25 : 0.14,
        ),
        backgroundColor: theme.colorScheme.surface,
        side: BorderSide(
          color: isSelected ? selectedColor : theme.colorScheme.outlineVariant,
          width: isSelected ? 1.2 : 0.7,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(
          color: isSelected
              ? (isDark ? theme.colorScheme.onSurface : selectedColor)
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _HistoryMessage(
      icon: Icons.history_rounded,
      title: l10n.emptyHistoryTitle,
      subtitle: l10n.emptyHistoryDescription,
    );
  }
}

class _HistoryMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HistoryMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                icon,
                size: 38,
                color: green,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
