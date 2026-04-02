import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class AboutUsSectionHeader extends StatelessWidget {
  const AboutUsSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.radius2xs),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title, style: context.textTheme.heading6.copyWith(color: context.appColors.text, height: 1.25)),
        ),
      ],
    );
  }
}
