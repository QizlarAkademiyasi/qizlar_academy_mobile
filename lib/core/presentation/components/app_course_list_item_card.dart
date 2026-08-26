import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_liquid_stretch.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_tablet_max_width.dart';

/// Kurslar katalogi va «Mening kurslarim» uchun umumiy ro‘yxat kartochkasi.
class AppCourseListItemCard extends StatelessWidget {
  const AppCourseListItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.mentorName,
    required this.rating,
    required this.reviewsCount,
    required this.durationSeconds,
    required this.onTap,
    this.tagLabel,
    this.titleMaxLines = 2,
    this.coverHeroCourseId,
  });

  final String imageUrl;
  final String title;
  final String mentorName;
  final double rating;
  final int reviewsCount;
  final int durationSeconds;
  final VoidCallback onTap;
  final String? tagLabel;
  final int titleMaxLines;

  /// `[Heroine]` uchun kurs id; berilsa muqova detallar ekraniga animatsiya bilan o‘tadi.
  final String? coverHeroCourseId;

  static String _formatReviewsCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final durationText = _durationText(l10n, durationSeconds);
    return AppTabletMaxWidth(
      child: AppLiquidStretch(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Gaimon.selection();
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.radius3xl,
              border: Border.all(color: context.appColors.stroke),
              color: context.appColors.onContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: _CourseCardImage(url: imageUrl, heroCourseId: coverHeroCourseId),
                    ),
                    if (tagLabel != null && tagLabel!.trim().isNotEmpty)
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
                          child: Text(tagLabel!, style: context.textTheme.bodyXSmallMedium.copyWith(color: AppColors.white)),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyXLargeSemibold.copyWith(color: context.appColors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mentorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          const Icon(LucideIcons.star, size: 14, color: Color(0xFFF6C344)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              l10n.myCoursesRatingReviewsLine(rating.toStringAsFixed(1), _formatReviewsCount(reviewsCount)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(LucideIcons.clock3, size: 14, color: context.appColors.secondaryGrey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              durationText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _durationText(AppLocalizations l10n, int totalSeconds) {
    if (totalSeconds <= 0) return l10n.courseDurationMinutes(0);
    final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
    final hours = safeSeconds ~/ 3600;
    final minutes = (safeSeconds % 3600) ~/ 60;
    if (hours <= 0) return l10n.courseDurationMinutes(minutes);
    if (minutes == 0) return l10n.myCoursesDurationHours(hours);
    return l10n.courseDurationHoursMinutes(hours, minutes);
  }
}

class _CourseCardImage extends StatelessWidget {
  const _CourseCardImage({required this.url, this.heroCourseId});

  final String url;
  final String? heroCourseId;

  static const double _height = 192;

  @override
  Widget build(BuildContext context) {
    final Widget content = !_hasValidImageUrl(url)
        ? _fallback(context)
        : AppCachedNetworkImage(imageUrl: url, width: double.infinity, height: _height, fit: BoxFit.cover, fallback: const AppNetworkImageFallbackCourse(iconSize: 34, tintAlpha: 0.08));
    final trimmedId = heroCourseId?.trim();
    if (trimmedId == null || trimmedId.isEmpty) return content;
    return content;
  }

  Widget _fallback(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _height,
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Icon(LucideIcons.bookOpen, color: AppColors.primary, size: 34),
    );
  }

  bool _hasValidImageUrl(String imageUrl) {
    final trimmed = imageUrl.trim();
    if (trimmed.isEmpty) return false;
    final parsed = Uri.tryParse(trimmed);
    return parsed != null && parsed.hasScheme && parsed.hasAuthority;
  }
}
