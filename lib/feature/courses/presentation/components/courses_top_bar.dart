import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CoursesTopBar extends StatelessWidget {
  const CoursesTopBar({
    super.key,
    required this.onNotificationTap,
    this.onBackTap,
  });

  final VoidCallback onNotificationTap;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (onBackTap != null) ...[
            AppBackButton.ghost(onTap: onBackTap!),
            const SizedBox(width: 8),
          ],
          Text(
            context.l10n.coursesAllTitle,
            style: context.textTheme.bodyXLargeSemibold.copyWith(
              color: context.appColors.text,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
