import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class TasksTopBar extends StatelessWidget {
  const TasksTopBar({super.key, required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          AppBackButton.ghost(onTap: onBackTap),
          const SizedBox(width: 4),
          Text(
            context.l10n.tasksTitle,
            style: context.textTheme.heading5.copyWith(
              color: context.appColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
