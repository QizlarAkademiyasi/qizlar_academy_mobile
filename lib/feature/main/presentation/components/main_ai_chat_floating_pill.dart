import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

/// BottomNav ustida markazda turadigan AI Chat kirish nuqtasi.
class MainAiChatFloatingPillOverlay extends StatelessWidget {
  const MainAiChatFloatingPillOverlay({
    super.key,
    required this.bottomNavigationOffset,
    required this.onTap,
  });

  static const double _navigationHeight = 64;
  static const double pillHeight = _navigationHeight - 10;
  static const double _navigationMarginBottom = 16;
  static const double _gapAboveNavigation = 10;

  final Offset bottomNavigationOffset;
  final VoidCallback onTap;

  static double resolveBottomOffset({
    required double safeAreaBottom,
    required double navigationTranslateY,
  }) {
    return safeAreaBottom +
        _navigationMarginBottom +
        _navigationHeight -
        navigationTranslateY +
        _gapAboveNavigation;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = resolveBottomOffset(
      safeAreaBottom: MediaQuery.paddingOf(context).bottom,
      navigationTranslateY: bottomNavigationOffset.dy,
    );
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottom,
      child: Center(child: _MainAiChatFloatingPill(onTap: onTap)),
    );
  }
}

class _MainAiChatFloatingPill extends StatelessWidget {
  const _MainAiChatFloatingPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final borderColor = (isDark ? AppColors.white : AppColors.textDark)
        .withValues(alpha: isDark ? 0.22 : 0.12);
    final pillShadow = isDark
        ? const <BoxShadow>[]
        : <BoxShadow>[
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: context.appColors.primary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
              spreadRadius: -3,
            ),
          ];
    final label = context.l10n.aiChatTitle;
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        key: const ValueKey('main-ai-chat-floating-pill'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          key: const ValueKey('main-ai-chat-pill-shadow'),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: pillShadow,
          ),
          child: SizedBox(
            height: MainAiChatFloatingPillOverlay.pillHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOnContainer : AppColors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: ColoredBox(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _AiSparkleMark(),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          color: isDark ? AppColors.white : AppColors.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AiSparkleMark extends StatelessWidget {
  const _AiSparkleMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFF725CFF),
            Color(0xFF3CB7FF),
            Color(0xFFE8357D),
            Color(0xFFFF8A4C),
            Color(0xFF725CFF),
          ],
        ),
      ),
      child: const Icon(LucideIcons.sparkles, color: AppColors.white, size: 15),
    );
  }
}
