import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_liquid_stretch.dart';

/// BottomNav ustida markazda turadigan AI Chat kirish nuqtasi.
class MainAiChatFloatingPillOverlay extends StatelessWidget {
  const MainAiChatFloatingPillOverlay({
    super.key,
    required this.isBottomNavMinimized,
    required this.isExtraMenuExpanded,
    required this.bottomNavigationOffset,
    required this.onTap,
  });

  static const double _navigationHeight = 64;
  static const double _compactNavigationHeight = 50;
  static const double pillHeight = _compactNavigationHeight - 10;
  static const double _navigationMarginBottom = 16;
  static const double _compactNavigationMarginBottom = 8;
  static const double _gapAboveNavigation = 10;

  final bool isBottomNavMinimized;
  final bool isExtraMenuExpanded;
  final Offset bottomNavigationOffset;
  final VoidCallback onTap;

  static double resolveBottomOffset({
    required double safeAreaBottom,
    required bool isBottomNavMinimized,
    required double navigationTranslateY,
  }) {
    final navigationHeight = isBottomNavMinimized
        ? _compactNavigationHeight
        : _navigationHeight;
    final navigationMargin = isBottomNavMinimized
        ? _compactNavigationMarginBottom
        : _navigationMarginBottom;
    return safeAreaBottom +
        navigationMargin +
        navigationHeight -
        navigationTranslateY +
        _gapAboveNavigation;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = resolveBottomOffset(
      safeAreaBottom: MediaQuery.paddingOf(context).bottom,
      isBottomNavMinimized: isBottomNavMinimized,
      navigationTranslateY: bottomNavigationOffset.dy,
    );
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      left: 0,
      right: 0,
      bottom: bottom,
      child: IgnorePointer(
        ignoring: isExtraMenuExpanded,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          offset: isExtraMenuExpanded ? const Offset(0, 0.25) : Offset.zero,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isExtraMenuExpanded ? 0 : 1,
            child: Center(child: _MainAiChatFloatingPill(onTap: onTap)),
          ),
        ),
      ),
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
      child: AppLiquidStretch.compact(
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
              child: LiquidGlass.withOwnLayer(
                settings: LiquidGlassSettings(
                  blur: 32,
                  thickness: isDark ? 16 : 18,
                  glassColor:
                      (isDark ? AppColors.white.withValues(alpha: 0.14) : AppColors.white.withValues(alpha: 0.68)),
                  lightIntensity: isDark ? 0.82 : 0.72,
                  ambientStrength: 0.22,
                  refractiveIndex: isDark ? 1.25 : 1.15,
                  saturation: 1.20,
                  chromaticAberration: 0.024,
                ),
                shape: LiquidRoundedSuperellipse(
                  borderRadius: 30,
                  side: BorderSide(color: borderColor, width: 0.8),
                ),
                child: ColoredBox(
                  color: (isDark ? AppColors.darkOnContainer : AppColors.white)
                      .withValues(alpha: isDark ? 0.75 : 0.68),
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
