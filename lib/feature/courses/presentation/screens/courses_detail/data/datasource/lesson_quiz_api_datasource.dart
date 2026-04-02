import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/lesson_quiz_already_submitted_exception.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';

/// REST: `/api/v1/quiz/*`
class LessonQuizApiDatasource {
  const LessonQuizApiDatasource(this._dio);

  final Dio _dio;

  Future<List<LessonQuizQuestionModel>> fetchQuestionsByLessonId(String lessonId) async {
    final response = await _dio.get<dynamic>(UserApis.quizQuestionsByLessonId(lessonId));
    final envelope = _asMap(response.data);
    final data = envelope['data'];
    if (data is! List) return const [];
    return data.map((e) => _parseQuestion(_asMap(e))).where((q) => q.id.isNotEmpty).toList(growable: false);
  }

  Future<bool> checkAnswer({required String quizId, required List<String> selectedOptionIds}) async {
    final response = await _dio.post<dynamic>(
      UserApis.quizCheckAnswer,
      data: <String, dynamic>{
        'quizId': quizId,
        'selectedOptionIds': selectedOptionIds,
      },
    );
    final envelope = _asMap(response.data);
    final inner = _asMap(envelope['data']);
    return inner['isCorrect'] == true;
  }

  Future<LessonQuizSubmitResultModel> submitLessonQuiz({
    required String lessonId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        UserApis.quizSubmit,
        data: <String, dynamic>{
          'lessonId': lessonId,
          'answers': answers,
        },
      );
      final envelope = _asMap(response.data);
      final inner = _asMap(envelope['data']);
      return LessonQuizSubmitResultModel(
        correctAnswerCount: _parseInt(inner['correctAnswerCount']),
        totalCount: _parseInt(inner['totalCount']),
        isFail: inner['isFail'] == true,
      );
    } on DioException catch (e) {
      if (_isQuizAlreadySubmittedResponse(e)) {
        throw const LessonQuizAlreadySubmittedException();
      }
      rethrow;
    }
  }

  bool _isQuizAlreadySubmittedResponse(DioException e) {
    if (e.response?.statusCode != 400) return false;
    final data = e.response?.data;
    var text = '';
    if (data is Map) {
      text = '${data['message'] ?? data['error'] ?? ''}';
    } else if (data is String) {
      text = data;
    }
    final lower = text.toLowerCase();
    return lower.contains('already submitted') || lower.contains('already_submitted');
  }

  LessonQuizQuestionModel _parseQuestion(Map<String, dynamic> raw) {
    final typeRaw = (raw['type'] ?? '').toString().toUpperCase().trim();
    final type = typeRaw.contains('MULTIPLE') ? LessonQuizQuestionType.multipleChoice : LessonQuizQuestionType.singleChoice;

    final mediaRaw = (raw['mediaType'] ?? '').toString().toUpperCase().trim();
    final mediaType = mediaRaw.contains('IMAGE') ? LessonQuizMediaType.image : LessonQuizMediaType.text;

    final optionsRaw = raw['options'];
    final options = <LessonQuizOptionModel>[];
    if (optionsRaw is List) {
      var i = 0;
      for (final o in optionsRaw) {
        final m = _asMap(o);
        var id = (m['id'] ?? '').toString();
        if (id.isEmpty) id = 'opt_${raw['id']}_$i';
        i++;
        options.add(
          LessonQuizOptionModel(
            id: id,
            value: (m['value'] ?? '').toString(),
            link: Apis.resolveUrl((m['link'] ?? '').toString()),
            type: (m['type'] ?? 'TEXT').toString(),
          ),
        );
      }
    }

    return LessonQuizQuestionModel(
      id: (raw['id'] ?? '').toString(),
      type: type,
      mediaType: mediaType,
      question: (raw['question'] ?? '').toString(),
      options: options,
    );
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }

  int _parseInt(dynamic v) => int.tryParse('${v ?? 0}') ?? 0;
}
