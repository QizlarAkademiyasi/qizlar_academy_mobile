import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

/// Kurslar katalogi va «Mening kurslarim» uchun umumiy ro‘yxat kartochkasi.
class AppCourseListItemCard extends StatelessWidget {
  const AppCourseListItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.mentorName,
    required this.rating,
    required this.reviewsCount,
    required this.durationHours,
    required this.onTap,
    this.tagLabel,
    this.titleMaxLines = 2,
  });

  final String imageUrl;
  final String title;
  final String mentorName;
  final double rating;
  final int reviewsCount;
  final int durationHours;
  final VoidCallback onTap;
  final String? tagLabel;
  final int titleMaxLines;

  static String _formatReviewsCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Bounce(
      tilt: false,
      onTap: () {
        Gaimon.selection();
        onTap();
      },
      child: Container(
        padding: AppPadding.paddingSm,
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
                  child: _CourseCardImage(url: imageUrl),
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
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.star, size: 14, color: Color(0xFFF6C344)),
                      const SizedBox(width: 4),
                      Text(
                        l10n.myCoursesRatingReviewsLine(rating.toStringAsFixed(1), _formatReviewsCount(reviewsCount)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey),
                      ),
                      const SizedBox(width: 8),
                      Icon(LucideIcons.clock3, size: 14, color: context.appColors.secondaryGrey),
                      const SizedBox(width: 4),
                      Text(l10n.myCoursesDurationHours(durationHours), style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCardImage extends StatelessWidget {
  const _CourseCardImage({required this.url});

  final String url;

  static const double _height = 156;

  @override
  Widget build(BuildContext context) {
    if (!_hasValidImageUrl(url)) {
      return _fallback(context);
    }
    return AppCachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      height: _height,
      fit: BoxFit.cover,
      fallback: const AppNetworkImageFallbackCourse(iconSize: 34, tintAlpha: 0.08),
    );
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
