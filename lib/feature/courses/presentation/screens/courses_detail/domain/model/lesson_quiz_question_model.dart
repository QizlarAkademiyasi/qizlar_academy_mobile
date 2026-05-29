import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum LessonQuizQuestionType { singleChoice, multipleChoice }

enum LessonQuizMediaType { text, image, unknown }

class LessonQuizOptionModel extends Equatable {
  const LessonQuizOptionModel({
    required this.id,
    required this.value,
    required this.link,
    required this.type,
    this.isCorrect,
  });

  final String id;
  final String value;
  final String link;
  final String type;

  final bool? isCorrect;

  @override
  List<Object?> get props => [id, value, link, type, isCorrect];
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

  bool isSelectionCorrect(List<String> selectedOptionIds) {
    final selected = selectedOptionIds.toSet();
    if (type == LessonQuizQuestionType.singleChoice) {
      if (selected.length != 1) return false;
      final chosenId = selected.single;
      for (final o in options) {
        if (o.id == chosenId) return o.isCorrect == true;
      }
      return false;
    }
    final correctIds = <String>{};
    for (final o in options) {
      if (o.isCorrect == true) correctIds.add(o.id);
    }
    if (correctIds.isEmpty) return false;
    return selected.length == correctIds.length && selected.containsAll(correctIds);
  }

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
