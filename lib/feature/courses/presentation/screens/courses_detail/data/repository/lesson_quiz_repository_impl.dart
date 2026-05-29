import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/datasource/lesson_quiz_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';

class LessonQuizRepositoryImpl implements LessonQuizRepository {
  LessonQuizRepositoryImpl(this._api);

  final LessonQuizApiDatasource _api;
  final Map<String, List<LessonQuizQuestionModel>> _questionCache = {};

  @override
  Future<List<LessonQuizQuestionModel>> fetchQuestionsForLesson(String lessonId) async {
    final key = lessonId.trim();
    if (key.isEmpty) return const [];
    final cached = _questionCache[key];
    if (cached != null) return cached;
    final list = await _api.fetchQuestionsByLessonId(key);
    _questionCache[key] = list;
    return list;
  }

  @override
  Future<LessonQuizSubmitResultModel> submitLessonQuiz({
    required String lessonId,
    required List<LessonQuizAnswerPayload> answers,
  }) {
    final body = answers
        .map(
          (a) => <String, dynamic>{
            'quizId': a.quizId,
            'selectedOptionIds': a.selectedOptionIds,
          },
        )
        .toList(growable: false);
    return _api.submitLessonQuiz(lessonId: lessonId, answers: body);
  }

  @override
  void clearCacheForLesson(String lessonId) {
    _questionCache.remove(lessonId.trim());
  }
}
