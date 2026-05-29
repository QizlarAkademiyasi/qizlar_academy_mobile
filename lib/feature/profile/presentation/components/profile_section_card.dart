import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: context.textTheme.bodyMediumSemibold.copyWith(
            color: context.appColors.grey,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusXl,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
