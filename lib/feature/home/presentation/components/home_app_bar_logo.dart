import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Figma header markazidagi «Qizlar Akademiyasi» wordmark (175×18 viewBox).
class HomeAppBarLogo extends StatelessWidget {
  const HomeAppBarLogo({super.key});

  static const String _assetPath =
      'packages/qizlar_academy_kit/assets/appbar/appBar_logo.svg';

  static const double _height = 18;

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.text;
    return Semantics(
      label: 'Qizlar Akademiyasi',
      child: SvgPicture.asset(
        _assetPath,
        key: const ValueKey('home-app-bar-logo'),
        height: _height,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
