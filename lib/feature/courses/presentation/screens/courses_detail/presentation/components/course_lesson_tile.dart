import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';

/// Modul ichidagi dars qatori (leading squircle, matn, play / qulf) — curriculum UI.
class CourseLessonTile extends StatelessWidget {
  const CourseLessonTile({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isActive = false,
    this.forceEnrollmentLock = false,
    this.guestPreviewLessonId,
    this.onGuestAuthRequired,
    this.modulePrerequisiteLocked = false,
    this.onModulePrerequisiteBlocked,
  });

  final CourseLessonModel lesson;
  final VoidCallback? onTap;
  final bool isActive;

  /// Ro‘yxatdan o‘tgan, lekin kursga hali yozilmagan — barcha darslar qulflangan ko‘rinadi.
  final bool forceEnrollmentLock;

  /// Mehmon: faqat shu id dagi dars ochiq; boshqa darslarda qulf + [onGuestAuthRequired].
  final String? guestPreviewLessonId;
  final VoidCallback? onGuestAuthRequired;

  /// Oldingi modul tugamaguncha keyingi modul darslari qulflangan.
  final bool modulePrerequisiteLocked;
  final VoidCallback? onModulePrerequisiteBlocked;

  /// Modul ro‘yxatida divider indent hisobi uchun (tashqaridan import qilinadi).
  static const double leadingBadgeSize = 40;

  static const double _leadingRadius = 12;
  static const double _trailingActionSize = 24;
  static const double _trailingActionSizeActive = 28;

  void _handleTap() {
    Gaimon.light();
  }

  @override
  Widget build(BuildContext context) {
    final isGuestPreview = guestPreviewLessonId != null && lesson.id == guestPreviewLessonId;
    final enrollmentLocked = ((lesson.isLocked && !isGuestPreview) || forceEnrollmentLock);
    final guestRestricted = guestPreviewLessonId != null && !isGuestPreview && onGuestAuthRequired != null;
    final looksLocked = enrollmentLocked || guestRestricted || modulePrerequisiteLocked;

    final titleColor = looksLocked ? context.appColors.grey : context.appColors.text;
    final showActiveFrame = isActive && !looksLocked;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final contentPadding = AppPadding.paddingLg.copyWith(top: 14, bottom: 14);

    final row = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LessonOrderBadge(order: lesson.order, locked: looksLocked, active: showActiveFrame, isDark: isDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMediumSemibold.copyWith(color: titleColor, height: 1.25),
                ),
                const SizedBox(height: 4),
                Text(lesson.duration, style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (looksLocked)
            Container(
              width: _trailingActionSize,
              height: _trailingActionSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.curriculumLessonLockedSurfaceDark : AppColors.curriculumLessonLockedSurfaceLight,
              ),
              child: Icon(
                LucideIcons.lock,
                size: 12,
                color: isDark ? AppColors.curriculumLessonLockedFgDark : AppColors.curriculumLessonLockedFgLight,
              ),
            )
          else
            Container(
              width: showActiveFrame ? _trailingActionSizeActive : _trailingActionSize,
              height: showActiveFrame ? _trailingActionSizeActive : _trailingActionSize,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
              child: Icon(LucideIcons.play, color: AppColors.white, size: showActiveFrame ? 14 : 12),
            ),
        ],
    );

    final activeRowBg = isDark ? AppColors.curriculumLessonActiveRowDark : AppColors.curriculumLessonActiveRowLight;

    final body = showActiveFrame
        ? Container(
            width: double.infinity,
            color: activeRowBg,
            child: Padding(padding: contentPadding, child: row),
          )
        : Padding(padding: contentPadding, child: row);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _handleTap();
        if (guestRestricted) {
          onGuestAuthRequired?.call();
          return;
        }
        if (modulePrerequisiteLocked) {
          onModulePrerequisiteBlocked?.call();
          return;
        }
        if (enrollmentLocked) return;
        onTap?.call();
      },
      child: body,
    );
  }
}

class _LessonOrderBadge extends StatelessWidget {
  const _LessonOrderBadge({required this.order, required this.locked, required this.active, required this.isDark});

  final int order;
  final bool locked;
  final bool active;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = order.toString().padLeft(2, '0');

    late final Color bg;
    late final Color fg;
    if (locked) {
      bg = isDark ? AppColors.curriculumLessonLockedSurfaceDark : AppColors.curriculumLessonLockedSurfaceLight;
      fg = isDark ? AppColors.curriculumLessonLockedFgDark : AppColors.curriculumLessonLockedFgLight;
    } else if (active) {
      bg = isDark ? AppColors.curriculumLessonActiveBadgeBgDark : AppColors.curriculumLessonActiveBadgeBgLight;
      fg = AppColors.primary;
    } else {
      bg = AppColors.primary.withValues(alpha: 0.14);
      fg = AppColors.primary;
    }

    final decoration = BoxDecoration(color: bg, shape: active ? BoxShape.circle : BoxShape.rectangle, borderRadius: active ? null : BorderRadius.circular(CourseLessonTile._leadingRadius));

    return Container(
      width: CourseLessonTile.leadingBadgeSize,
      height: CourseLessonTile.leadingBadgeSize,
      alignment: Alignment.center,
      decoration: decoration,
      child: Text(text, style: context.textTheme.bodySmallBold.copyWith(color: fg)),
    );
  }
}
