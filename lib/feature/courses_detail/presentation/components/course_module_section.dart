import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_module_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_lesson_tile.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';

class CourseModuleSection extends StatefulWidget {
  const CourseModuleSection({
    super.key,
    required this.module,
    required this.onLessonTap,
    this.selectedLessonId,
  });

  final CourseModuleModel module;
  final ValueChanged<String> onLessonTap;
  final String? selectedLessonId;

  @override
  State<CourseModuleSection> createState() => _CourseModuleSectionState();
}

class _CourseModuleSectionState extends State<CourseModuleSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.module.isExpandedByDefault;
  }

  @override
  void didUpdateWidget(covariant CourseModuleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.module.id != widget.module.id) {
      _expanded = widget.module.isExpandedByDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;

    return Container(
      padding: AppPadding.paddingLg,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Bounce(
            tilt: false,
            onTap: () {
              Gaimon.light();
              setState(() => _expanded = !_expanded);
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: context.textTheme.bodyLargeBold.copyWith(
                          color: context.appColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            module.progressText,
                            style: context.textTheme.bodyXSmallRegular.copyWith(
                              color: context.appColors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            module.totalDurationText,
                            style: context.textTheme.bodyXSmallRegular.copyWith(
                              color: context.appColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  color: context.appColors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 14),
            if (module.lessons.isEmpty)
              const TgsEmptyContent(message: 'Hali darslar yo‘q!')
            else
              Column(
                children: [
                  for (final lesson in module.lessons) ...[
                    CourseLessonTile(
                      lesson: lesson,
                      isActive: widget.selectedLessonId == lesson.id,
                      onTap: () => widget.onLessonTap(lesson.id),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }
}
