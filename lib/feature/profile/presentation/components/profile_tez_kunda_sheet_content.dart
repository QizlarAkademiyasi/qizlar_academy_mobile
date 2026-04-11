import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Profil “Tez kunda” bottom sheet: markazda `.tgs` quyon + sarlavha + matn.
class ProfileTezKundaSheetContent extends StatelessWidget {
  const ProfileTezKundaSheetContent({super.key, required this.title, required this.message});

  final String title;
  final String message;

  static const double _animationSide = 132;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _animationSide + 8,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 12,
                child: IgnorePointer(
                  child: Container(
                    width: 112,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 36, spreadRadius: 4, color: context.appColors.primary.withValues(alpha: 0.22))],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _animationSide,
                height: _animationSide,
                child: Lottie.asset(UiKitAssets.lottie.rabbit.attantuibedRabbit, fit: BoxFit.contain, repeat: true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.heading6.copyWith(color: context.appColors.text),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.text, height: 1.35),
        ),
      ],
    );
  }
}
