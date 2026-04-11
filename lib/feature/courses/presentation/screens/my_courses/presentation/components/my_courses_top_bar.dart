import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class MyCoursesTopBar extends StatelessWidget {
  const MyCoursesTopBar({super.key, required this.title, required this.onBackTap});

  final String title;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 8, 12),
      child: Row(
        children: [
          AppBackButton(onTap: onBackTap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.heading6.copyWith(color: context.appColors.text),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
