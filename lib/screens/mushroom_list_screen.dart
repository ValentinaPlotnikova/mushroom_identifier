import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../models/mushroom.dart';
import '../services/firestore_service.dart';
import '../widgets/mushroom_list_item.dart';

class MushroomListScreen extends StatefulWidget {
  const MushroomListScreen({super.key});

  @override
  State<MushroomListScreen> createState() => _MushroomListScreenState();
}

class _MushroomListScreenState extends State<MushroomListScreen> {
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  late final Stream<List<Mushroom>> _mushroomsStream;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _mushroomsStream = _firestore.watchMushrooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Mushroom> _filter(
    List<Mushroom> mushrooms,
    String language,
  ) {
    final query = _query.trim().toLowerCase();
    final isEnglish = language == 'en';

    final list = [...mushrooms]..sort((a, b) {
        final nameA = isEnglish ? a.nameLatin : a.nameRu;
        final nameB = isEnglish ? b.nameLatin : b.nameRu;

        return nameA.toLowerCase().compareTo(nameB.toLowerCase());
      });

    if (query.isEmpty) return list;

    return list.where((mushroom) {
      return mushroom.nameRu.toLowerCase().contains(query) ||
          mushroom.nameLatin.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final language = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.encyclopedia),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _query = value);
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.encyclopediaSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        tooltip: l10n.clearSearch,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: scheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: scheme.outlineVariant,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: scheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Mushroom>>(
              stream: _mushroomsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return _EncyclopediaMessage(
                    icon: Icons.cloud_off_outlined,
                    title: l10n.encyclopediaLoadError,
                  );
                }

                final filtered = _filter(
                  snapshot.data ?? <Mushroom>[],
                  language,
                );

                if (filtered.isEmpty) {
                  return _EncyclopediaMessage(
                    icon: _query.trim().isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.menu_book_outlined,
                    title: _query.trim().isNotEmpty
                        ? l10n.noResultsFound
                        : l10n.encyclopediaEmpty,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mushroom = filtered[index];

                    return MushroomListItem(
                      mushroom: mushroom,
                      onTap: () => context.push('/mushroom/${mushroom.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EncyclopediaMessage extends StatelessWidget {
  final IconData icon;
  final String title;

  const _EncyclopediaMessage({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
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
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
