import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_more_menu_items.dart';

/// Main shellning 5-tab (index 4) — More dan tanlangan bo‘lim.
class MainMoreTabPage extends StatelessWidget {
  const MainMoreTabPage({
    super.key,
    required this.selectedItemIndex,
    required this.onItemSelected,
  });

  final int? selectedItemIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (selectedItemIndex != null) {
      final item = kMainMoreMenuItems[selectedItemIndex!];
      return AppPageScaffold(
        title: item.title,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: Center(
          child: Text(item.title, style: context.theme.textTheme.titleMedium),
        ),
      );
    }

    if (Platform.isIOS) {
      return ColoredBox(
        color: context.theme.scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.mainMoreEmptyHint,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: context.appColors.text.withValues(alpha: 0.72),
              ),
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.15,
        ),
        itemCount: kMainMoreMenuItems.length,
        itemBuilder: (context, index) {
          final item = kMainMoreMenuItems[index];
          return Material(
            color: context.appColors.background,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onItemSelected(index),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 36, color: item.tint),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.appColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
