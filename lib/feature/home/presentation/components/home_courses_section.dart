import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_all_courses_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';

class HomeCoursesSection extends StatelessWidget {
  const HomeCoursesSection({
    super.key,
    required this.courses,
    required this.onCourseTap,
    required this.onAllCoursesTap,
    this.isLoading = false,
  });

  final List<CourseModel> courses;
  final ValueChanged<CourseModel> onCourseTap;
  final VoidCallback onAllCoursesTap;
  final bool isLoading;

  static const double _gridGap = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.mainTabCourses,
            style: context.textTheme.heading5.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: AppGap.gapMd),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - _gridGap) / 2;
              final tiles = <Widget>[
                if (isLoading)
                  for (final course in courses)
                    SizedBox(
                      width: tileWidth,
                      child: HomeCourseCard(course: course, isLoading: true),
                    )
                else ...[
                  for (final course in courses)
                    SizedBox(
                      width: tileWidth,
                      child: HomeCourseCard(
                        course: course,
                        onTap: () => onCourseTap(course),
                      ),
                    ),
                  SizedBox(
                    width: tileWidth,
                    height: tileWidth,
                    child: HomeAllCoursesCard(onTap: onAllCoursesTap),
                  ),
                ],
              ];
              return Wrap(
                spacing: _gridGap,
                runSpacing: _gridGap,
                children: tiles,
              );
            },
          ),
        ],
      ),
    );
  }
}
