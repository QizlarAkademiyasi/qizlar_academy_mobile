import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_bottom_action.dart';

/// Video player: dars tugagan, test bor va hali topshirilmagan bo‘lsa pastki CTA.
class LessonPlayerQuizCta extends StatefulWidget {
  const LessonPlayerQuizCta({super.key, required this.lessonId, required this.onOpenQuiz});

  final String lessonId;
  final VoidCallback onOpenQuiz;

  @override
  State<LessonPlayerQuizCta> createState() => _LessonPlayerQuizCtaState();
}

class _LessonPlayerQuizCtaState extends State<LessonPlayerQuizCta> {
  late final Future<int> _countFuture;

  @override
  void initState() {
    super.initState();
    _countFuture = _load();
  }

  Future<int> _load() async {
    try {
      final list = await getIt<LessonQuizRepository>().fetchQuestionsForLesson(widget.lessonId);
      return list.length;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _countFuture,
      builder: (context, snapshot) {
        final n = snapshot.data ?? 0;
        if (n == 0) return const SizedBox.shrink();
        return CourseBottomAction(
          label: context.l10n.lessonQuizGoToTest,
          showLeadingIcon: true,
          onTap: widget.onOpenQuiz,
        );
      },
    );
  }
}
