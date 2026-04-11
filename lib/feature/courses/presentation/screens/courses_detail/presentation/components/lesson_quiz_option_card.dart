import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Test variantlari: tanlangan, tekshirilgan (yashil / qizil) holatlari.
class LessonQuizOptionCard extends StatelessWidget {
  const LessonQuizOptionCard({
    super.key,
    required this.letter,
    required this.label,
    required this.selected,
    required this.revealed,
    required this.wasCorrectChoice,
    required this.onTap,
    this.enabled = true,
  });

  final String letter;
  final String label;
  final bool selected;
  final bool revealed;
  final bool? wasCorrectChoice;
  final VoidCallback onTap;

  /// `false` bo‘lsa (masalan, `checking`): bosilishlar rad etiladi.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color? fill;
    final Color letterBg;
    final Color letterFg;
    final Color textColor = context.appColors.text;

    if (revealed && selected) {
      final ok = wasCorrectChoice == true;
      borderColor = ok ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
      fill = ok ? AppColors.otherLightGreen.withValues(alpha: 0.08) : AppColors.otherPink.withValues(alpha: 0.06);
      letterBg = ok ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
      letterFg = AppColors.white;
    } else if (revealed && !selected) {
      borderColor = context.appColors.stroke;
      fill = null;
      letterBg = context.appColors.onContainer;
      letterFg = context.appColors.grey;
    } else if (selected) {
      borderColor = AppColors.primary;
      fill = AppColors.primary.withValues(alpha: 0.06);
      letterBg = AppColors.primary;
      letterFg = AppColors.white;
    } else {
      borderColor = context.appColors.stroke;
      fill = null;
      letterBg = context.appColors.onContainer;
      letterFg = context.appColors.grey;
    }

    return Bounce(
      tilt: false,
      onTap: revealed || !enabled
          ? () {}
          : () {
              Gaimon.light();
              onTap();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: fill ?? context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: borderColor, width: selected || (revealed && selected) ? 1.5 : 1),
          boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: letterBg,
                shape: BoxShape.circle,
                border: Border.all(color: revealed && !selected ? context.appColors.stroke : context.appColors.stroke),
              ),
              child: Text(letter, style: context.textTheme.bodySmallBold.copyWith(color: letterFg)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: context.textTheme.bodyMediumRegular.copyWith(color: textColor, height: 1.35)),
            ),
            if (revealed && selected) ...[
              const SizedBox(width: 8),
              Icon(wasCorrectChoice == true ? LucideIcons.circleCheck : LucideIcons.circleX, color: wasCorrectChoice == true ? const Color(0xFF22C55E) : const Color(0xFFEF4444), size: 22),
            ],
          ],
        ),
      ),
    );
  }
}
