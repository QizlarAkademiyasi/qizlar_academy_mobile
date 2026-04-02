import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeHeaderComponent extends StatelessWidget {
  const HomeHeaderComponent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onNotificationTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: context.appColors.background,
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMediumMedium.copyWith(
                      color: context.appColors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    style: context.textTheme.heading4.copyWith(
                      overflow: TextOverflow.ellipsis,
                      color: context.appColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Bounce(
            tilt: false,
            onTap: () {
              Gaimon.selection();
              onNotificationTap();
            },
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.appColors.onContainer,
                    boxShadow: [
                      BoxShadow(
                        color: context.appColors.shadow.withValues(
                          alpha: 0.005,
                        ),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    border: Border.all(color: context.appColors.stroke),
                  ),
                  child: Icon(
                    LucideIcons.bell,
                    size: 22,
                    color: context.appColors.text,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
