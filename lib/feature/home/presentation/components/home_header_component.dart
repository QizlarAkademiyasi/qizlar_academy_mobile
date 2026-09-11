import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeHeaderComponent extends StatelessWidget {
  const HomeHeaderComponent({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          key: const ValueKey('home-large-greeting'),
          style: context.textTheme.heading4.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: context.appColors.text,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class HomeHeaderActionButton extends StatelessWidget {
  const HomeHeaderActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.showIndicator = false,
  });

  static const double size = 48;

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Bounce(
        tilt: false,
        onTap: () {
          Gaimon.selection();
          onTap();
        },
        child: Stack(
          children: [
            Container(
              width: HomeHeaderActionButton.size,
              height: HomeHeaderActionButton.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.onContainer.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.shadow.withValues(alpha: 0.005),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: context.appColors.onContainer.withValues(alpha: 0.85),
                ),
              ),
              child: Icon(icon, size: 22, color: context.appColors.text),
            ),
            if (showIndicator)
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
    );
  }
}
