import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_quiz_tile.dart';

/// Darsdan keyin test qatorini ko‘rsatish: savollar bo‘lsa chiqadi (cache repository’da).
class LessonQuizListRow extends StatefulWidget {
  const LessonQuizListRow({
    super.key,
    required this.lesson,
    required this.onOpenQuiz,
    this.forceEnrollmentLock = false,
    this.guestPreviewLessonId,
    this.onGuestAuthRequired,
    this.modulePrerequisiteLocked = false,
    this.onModulePrerequisiteBlocked,
  });

  final CourseLessonModel lesson;
  final void Function(String lessonId) onOpenQuiz;
  final bool forceEnrollmentLock;
  final String? guestPreviewLessonId;
  final VoidCallback? onGuestAuthRequired;
  final bool modulePrerequisiteLocked;
  final VoidCallback? onModulePrerequisiteBlocked;

  @override
  State<LessonQuizListRow> createState() => _LessonQuizListRowState();
}

class _LessonQuizListRowState extends State<LessonQuizListRow> {
  late final Future<int> _countFuture;

  @override
  void initState() {
    super.initState();
    _countFuture = _loadCount();
  }

  Future<int> _loadCount() async {
    final session = getIt<AuthSessionCubit>().state;
    if (!session.isRegistered) return 0;
    try {
      final list = await getIt<LessonQuizRepository>().fetchQuestionsForLesson(widget.lesson.id);
      return list.length;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = getIt<AuthSessionCubit>().state;
    if (!session.isRegistered) return const SizedBox.shrink();

    return FutureBuilder<int>(
      future: _countFuture,
      builder: (context, snapshot) {
        final n = snapshot.data ?? 0;
        if (n == 0) return const SizedBox.shrink();
        final guestBlocked = widget.guestPreviewLessonId != null && widget.lesson.id != widget.guestPreviewLessonId;
        return CourseQuizTile(
          lesson: widget.lesson,
          questionCount: n,
          forceEnrollmentLock: widget.forceEnrollmentLock,
          guestBlocked: guestBlocked,
          onGuestAuthRequired: widget.onGuestAuthRequired,
          modulePrerequisiteLocked: widget.modulePrerequisiteLocked,
          onModulePrerequisiteBlocked: widget.onModulePrerequisiteBlocked,
          onTap: () => widget.onOpenQuiz(widget.lesson.id),
        );
      },
    );
  }
}
