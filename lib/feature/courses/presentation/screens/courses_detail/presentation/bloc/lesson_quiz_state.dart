part of 'lesson_quiz_bloc.dart';

enum LessonQuizUiStatus { loading, ready, checking, previewResult, failure }

class LessonQuizState extends Equatable {
  const LessonQuizState({
    this.status = LessonQuizUiStatus.loading,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedByQuizId = const {},
    this.revealedByQuizId = const {},
    this.message,
    this.startedAt,
  });

  final LessonQuizUiStatus status;
  final List<LessonQuizQuestionModel> questions;
  final int currentIndex;
  final Map<String, Set<String>> selectedByQuizId;
  final Map<String, bool> revealedByQuizId;
  final String? message;
  final DateTime? startedAt;

  LessonQuizQuestionModel? get currentQuestion {
    if (currentIndex < 0 || currentIndex >= questions.length) return null;
    return questions[currentIndex];
  }

  bool get isCurrentRevealed {
    final q = currentQuestion;
    if (q == null) return false;
    return revealedByQuizId.containsKey(q.id);
  }

  bool? get currentRevealCorrect {
    final q = currentQuestion;
    if (q == null) return null;
    return revealedByQuizId[q.id];
  }

  double get progressFraction {
    if (questions.isEmpty) return 0;
    return (currentIndex + 1) / questions.length;
  }

  LessonQuizState copyWith({
    LessonQuizUiStatus? status,
    List<LessonQuizQuestionModel>? questions,
    int? currentIndex,
    Map<String, Set<String>>? selectedByQuizId,
    Map<String, bool>? revealedByQuizId,
    String? message,
    DateTime? startedAt,
    bool clearMessage = false,
  }) {
    return LessonQuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedByQuizId: selectedByQuizId ?? this.selectedByQuizId,
      revealedByQuizId: revealedByQuizId ?? this.revealedByQuizId,
      message: clearMessage ? null : (message ?? this.message),
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentIndex,
    selectedByQuizId,
    revealedByQuizId,
    message,
    startedAt,
  ];
}
