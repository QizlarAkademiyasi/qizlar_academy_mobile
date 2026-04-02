import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';

/// Kurs detali hero: fon rasmi, pastga qorayuvchi gradient, shisha orqaga, pastda kategoriya + sarlavha + o‘qituvchi.
class CourseDetailsSliverHeader extends StatelessWidget {
  const CourseDetailsSliverHeader({super.key, required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return SliverAppBar(
      pinned: false,
      floating: false,
      stretch: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      expandedHeight: 230,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppCachedNetworkImage(
              imageUrl: course.coverImageUrl,
              fit: BoxFit.cover,
              fallback: const AppNetworkImageFallbackCoverTint(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.black.withValues(alpha: 0.15), AppColors.black.withValues(alpha: 0.25), AppColors.black.withValues(alpha: 0.82)],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              top: topInset + 10,
              left: 16,
              child: AppBackButton.glass(onTap: () => context.pop()),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 22,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (course.categoryName.trim().isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.white.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              course.categoryName.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyXSmallSemibold.copyWith(color: AppColors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.heading3.copyWith(color: AppColors.white, height: 1.15),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          course.teacherName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLargeMedium.copyWith(color: AppColors.white.withValues(alpha: 0.95)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          course.teacherName,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmallMedium.copyWith(color: AppColors.white.withValues(alpha: 0.92)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.white.withValues(alpha: 0.85), width: 1.2),
                          ),
                          child: Text(
                            course.teacherRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyXSmallSemibold.copyWith(color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
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
