import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class NotificationSettingsSwitchTile extends StatelessWidget {
  const NotificationSettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
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
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: context.textTheme.bodySmallRegular.copyWith(
                            color: context.appColors.secondaryGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.84,
                  child: Switch.adaptive(
                    value: value,
                    activeTrackColor: context.appColors.primary.withValues(
                      alpha: 0.5,
                    ),
                    activeThumbColor: context.appColors.primary,
                    onChanged: enabled ? onChanged : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: context.appColors.stroke),
      ],
    );
  }
}
