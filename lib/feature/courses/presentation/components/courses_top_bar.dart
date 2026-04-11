import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CoursesTopBar extends StatelessWidget {
  const CoursesTopBar({super.key, required this.onNotificationTap});

  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
      child: Row(
        children: [
          Expanded(
            child: Text(context.l10n.coursesAllTitle, style: context.textTheme.heading4.copyWith(color: context.appColors.text)),
          ),
        ],
      ),
    );
  }
}
