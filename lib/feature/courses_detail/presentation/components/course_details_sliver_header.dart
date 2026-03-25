import 'dart:ui';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';

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
      expandedHeight: 260,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: course.coverImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: AppColors.primary.withValues(alpha: 0.12)),
              errorWidget: (context, url, error) =>
                  Container(color: AppColors.primary.withValues(alpha: 0.12)),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.55),
                    AppColors.black.withValues(alpha: 0.15),
                    AppColors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            Positioned(
              top: topInset + 10,
              left: 16,
              child: AppBackButton.glass(
                onTap: () => context.pop(),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: ClipRRect(
                borderRadius: AppRadius.radius3xl,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: AppPadding.paddingLg,
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.18),
                      borderRadius: AppRadius.radius3xl,
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: course.teacherAvatarUrl,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 46,
                              height: 46,
                              color: AppColors.white.withValues(alpha: 0.25),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 46,
                              height: 46,
                              color: AppColors.white.withValues(alpha: 0.25),
                              child: const Icon(
                                LucideIcons.user,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                course.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.heading5.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      course.teacherName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textTheme.bodySmallMedium
                                          .copyWith(
                                            color: AppColors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: AppColors.white.withValues(
                                          alpha: 0.18,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      course.teacherRole,
                                      style: context.textTheme.bodyXSmallMedium
                                          .copyWith(
                                            color: AppColors.white.withValues(
                                              alpha: 0.92,
                                            ),
                                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
