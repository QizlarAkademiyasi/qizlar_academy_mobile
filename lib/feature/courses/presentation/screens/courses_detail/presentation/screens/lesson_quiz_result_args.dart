import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';

class LessonQuizResultArgs {
  const LessonQuizResultArgs({required this.result, required this.elapsed, this.pendingSubmit = false, this.lessonId = '', this.answers = const []});

  /// Ko‘rinadigan statistika (oldindan tekshiruv asosida yoki serverdan keyin).
  final LessonQuizSubmitResultModel result;
  final Duration elapsed;

  /// `true` bo‘lsa, «Davom etish» bosilganda `submitLessonQuiz` chaqiriladi.
  final bool pendingSubmit;
  final String lessonId;
  final List<LessonQuizAnswerPayload> answers;
}

/// [LessonQuizResultScreen] dan quizni boshidan boshlash uchun `context.pop` qiymati.
enum LessonQuizResultOutcome { retry }
