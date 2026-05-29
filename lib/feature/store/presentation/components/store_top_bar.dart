import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreTopBar extends StatelessWidget {
  const StoreTopBar({super.key, required this.title, required this.onBackTap, this.onHistoryTap});

  final String title;
  final VoidCallback onBackTap;
  final VoidCallback? onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          AppBackButton.ghost(onTap: onBackTap),
          const SizedBox(width: 8),
          Text(title, style: context.textTheme.bodyXLargeSemibold.copyWith(color: context.appColors.text)),
          const Spacer(),
          if (onHistoryTap != null)
            AppLiquidStretch.compact(
              child: IconButton(
                onPressed: onHistoryTap,
                icon: Icon(LucideIcons.history, color: context.appColors.text, size: 22),
              ),
            ),
        ],
      ),
    );
  }
}
