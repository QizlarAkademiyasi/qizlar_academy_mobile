import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';

class LessonQuizAnswerPayload {
  const LessonQuizAnswerPayload({required this.quizId, required this.selectedOptionIds});

  final String quizId;
  final List<String> selectedOptionIds;
}

abstract class LessonQuizRepository {
  Future<List<LessonQuizQuestionModel>> fetchQuestionsForLesson(String lessonId);

  Future<bool> checkAnswer({required String quizId, required List<String> selectedOptionIds});

  Future<LessonQuizSubmitResultModel> submitLessonQuiz({
    required String lessonId,
    required List<LessonQuizAnswerPayload> answers,
  });

  void clearCacheForLesson(String lessonId);
}
