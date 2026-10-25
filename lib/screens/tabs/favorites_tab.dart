import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/favorite.dart';
import '../../models/mushroom.dart';
import '../../providers/favorites_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/mushroom_list_item.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
      ),
      body: favoritesProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : favorites.isEmpty
              ? const _EmptyFavorites()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _DismissibleFavorite(
                      key: ValueKey(favorites[index].id),
                      favorite: favorites[index],
                    );
                  },
                ),
    );
  }
}

class _DismissibleFavorite extends StatefulWidget {
  final Favorite favorite;

  const _DismissibleFavorite({
    super.key,
    required this.favorite,
  });

  @override
  State<_DismissibleFavorite> createState() => _DismissibleFavoriteState();
}

class _DismissibleFavoriteState extends State<_DismissibleFavorite> {
  final FirestoreService _firestore = FirestoreService();
  late Future<Mushroom?> _future;

  @override
  void initState() {
    super.initState();
    _future = _firestore.getMushroom(widget.favorite.mushroomId);
  }

  @override
  void didUpdateWidget(covariant _DismissibleFavorite oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.favorite.mushroomId != widget.favorite.mushroomId) {
      _future = _firestore.getMushroom(widget.favorite.mushroomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFB3261E);
    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: ValueKey(widget.favorite.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        context.read<FavoritesProvider>().removeFromFavorites(
              widget.favorite.mushroomId,
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.favoriteRemoved),
          ),
        );
      },
      child: FutureBuilder<Mushroom?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _FavoritePlaceholder(
              state: _FavoritePlaceholderState.loading,
            );
          }

          if (snapshot.hasError) {
            return const _FavoritePlaceholder(
              state: _FavoritePlaceholderState.error,
              icon: Icons.cloud_off_outlined,
            );
          }

          final mushroom = snapshot.data;

          if (mushroom == null) {
            return const _FavoritePlaceholder(
              state: _FavoritePlaceholderState.notFound,
              icon: Icons.search_off_rounded,
            );
          }

          return MushroomListItem(
            mushroom: mushroom,
            onTap: () => context.push('/mushroom/${mushroom.id}'),
          );
        },
      ),
    );
  }
}

enum _FavoritePlaceholderState {
  loading,
  error,
  notFound,
}

class _FavoritePlaceholder extends StatelessWidget {
  final _FavoritePlaceholderState state;
  final IconData icon;

  const _FavoritePlaceholder({
    required this.state,
    this.icon = Icons.eco_outlined,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final title = switch (state) {
      _FavoritePlaceholderState.loading => l10n.loading,
      _FavoritePlaceholderState.error => l10n.favoriteLoadError,
      _FavoritePlaceholderState.notFound => l10n.favoriteNotFound,
    };

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 0.7,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: green,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: green,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.emptyFavoritesTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyFavoritesDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push('/encyclopedia'),
              icon: const Icon(Icons.menu_book_outlined),
              label: Text(l10n.openEncyclopedia),
              style: FilledButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
