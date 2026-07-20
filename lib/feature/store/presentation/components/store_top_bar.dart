import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreTopBar extends StatelessWidget {
  const StoreTopBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onHistoryTap,
  });

  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
      child: Row(
        children: [
          if (onBackTap != null) ...[
            AppBackButton.ghost(onTap: onBackTap!),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: context.textTheme.heading4.copyWith(
                color: context.appColors.text,
              ),
            ),
          ),
          if (onHistoryTap != null)
            AppLiquidStretch.compact(
              child: IconButton(
                onPressed: onHistoryTap,
                icon: Icon(
                  LucideIcons.history,
                  color: context.appColors.text,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
