import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/constants.dart';
import '../../models/identification.dart';
import '../../providers/history_provider.dart';
import '../../services/image_picker_service.dart';
import '../../widgets/identification_list_item.dart';
import '../capture_preview_screen.dart';
import '../../l10n/app_localizations.dart';

/// Главная вкладка приложения Mushroom Identifier.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ImagePickerService _picker = ImagePickerService();

  Future<void> _pick(CaptureSource source) async {
    try {
      final File? file = source == CaptureSource.camera
          ? await _picker.pickFromCamera()
          : await _picker.pickFromGallery();

      if (file == null || !mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CapturePreviewScreen(
            image: file,
            source: source,
          ),
        ),
      );
    } on ImageFormatException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Не удалось открыть изображение: $e');
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          28,
        ),
        children: [
          // Оригинальный листочек.
          // Оставляем без фона и обводок.
          const Icon(
            Icons.eco,
            size: 72,
            color: AppTheme.lightGreen,
          ),

          const SizedBox(height: 16),

          Text(
            l10n.identifyMushroomTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            l10n.identifyMushroomSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 28),

          // Выбор способа загрузки фотографии.
          _HomeCard(
            child: Column(
              children: [
                _HomeAction(
                  icon: Icons.photo_camera_outlined,
                  title: l10n.takePhoto,
                  subtitle: l10n.openCameraSubtitle,
                  onTap: () => _pick(CaptureSource.camera),
                ),
                const _HomeDivider(),
                _HomeAction(
                  icon: Icons.photo_library_outlined,
                  title: l10n.chooseGallery,
                  subtitle: l10n.chooseGallerySubtitle,
                  onTap: () => _pick(CaptureSource.gallery),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _HomeCard(
            child: _HomeAction(
              icon: Icons.menu_book_outlined,
              title: l10n.encyclopedia,
              subtitle: l10n.encyclopediaSubtitle,
              onTap: () => context.push('/encyclopedia'),
            ),
          ),

          const SizedBox(height: 28),

          const _RecentHistory(),
        ],
      ),
    );
  }
}

/// Общий контейнер карточек.
class _HomeCard extends StatelessWidget {
  final Widget child;

  const _HomeCard({
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
      child: child,
    );
  }
}

/// Разделитель внутри карточки.
class _HomeDivider extends StatelessWidget {
  const _HomeDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 72,
      endIndent: 16,
    );
  }
}

/// Кнопка-действие в стиле профиля и настроек.
class _HomeAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = AppTheme.primaryGreen;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isDark ? const Color(0xFF81C784) : green,
                size: 25,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    softWrap: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
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

/// Превью последних трёх определений.
class _RecentHistory extends StatelessWidget {
  const _RecentHistory();

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final List<Identification> recent = history.recent(3);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.history_rounded,
              color: AppTheme.primaryGreen,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.recentIdentifications,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (history.isLoading && recent.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (recent.isEmpty)
          _HomeCard(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: AppTheme.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l10n.emptyRecentHistory,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...recent.map(
            (item) => IdentificationListItem(
              identification: item,
              onTap: () => context.push('/history/${item.id}'),
            ),
          ),
      ],
    );
  }
}
