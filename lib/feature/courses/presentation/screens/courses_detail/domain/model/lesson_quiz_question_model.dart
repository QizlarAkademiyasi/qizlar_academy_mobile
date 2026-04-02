import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum LessonQuizQuestionType { singleChoice, multipleChoice }

enum LessonQuizMediaType { text, image, unknown }

class LessonQuizOptionModel extends Equatable {
  const LessonQuizOptionModel({required this.id, required this.value, required this.link, required this.type});

  final String id;
  final String value;
  final String link;
  final String type;

  @override
  List<Object?> get props => [id, value, link, type];
}

class LessonQuizQuestionModel extends Equatable {
  const LessonQuizQuestionModel({
    required this.id,
    required this.type,
    required this.mediaType,
    required this.question,
    required this.options,
  });

  final String id;
  final LessonQuizQuestionType type;
  final LessonQuizMediaType mediaType;
  final String question;
  final List<LessonQuizOptionModel> options;

  @override
  List<Object?> get props => [id, type, mediaType, question, options];
}

class LessonQuizSubmitResultModel extends Equatable {
  const LessonQuizSubmitResultModel({
    required this.correctAnswerCount,
    required this.totalCount,
    required this.isFail,
  });

  final int correctAnswerCount;
  final int totalCount;
  final bool isFail;

  @override
  List<Object?> get props => [correctAnswerCount, totalCount, isFail];
}
