import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfilePreferenceTile extends StatelessWidget {
  const ProfilePreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(BuildContext context, bool value) onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.appColors.iconSecondary,
                  borderRadius: AppRadius.radiusMd,
                ),
                child: Icon(icon, size: 18, color: context.appColors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.bodyMediumSemibold.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmallRegular.copyWith(
                        color: context.appColors.secondaryGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.84,
                child: Builder(
                  builder: (switchContext) => Switch.adaptive(
                    value: value,
                    activeTrackColor: context.appColors.primary.withValues(
                      alpha: 0.5,
                    ),
                    activeThumbColor: context.appColors.primary,
                    onChanged: (newValue) => onChanged(switchContext, newValue),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: context.appColors.stroke,
            indent: 54,
          ),
      ],
    );
  }
}
