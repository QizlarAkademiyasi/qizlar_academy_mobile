import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';

part 'lesson_quiz_event.dart';
part 'lesson_quiz_state.dart';

class LessonQuizBloc extends Bloc<LessonQuizEvent, LessonQuizState> {
  LessonQuizBloc(this._repository, {required this.lessonId}) : super(const LessonQuizState()) {
    on<LessonQuizStarted>(_onStarted);
    on<LessonQuizOptionToggled>(_onOptionToggled);
    on<LessonQuizPrimaryPressed>(_onPrimaryPressed);
  }

  final LessonQuizRepository _repository;
  final String lessonId;

  Future<void> _onStarted(LessonQuizStarted event, Emitter<LessonQuizState> emit) async {
    emit(state.copyWith(status: LessonQuizUiStatus.loading, clearMessage: true));
    try {
      final questions = await _repository.fetchQuestionsForLesson(lessonId);
      if (questions.isEmpty) {
        emit(state.copyWith(status: LessonQuizUiStatus.failure, message: 'empty_quiz'));
        return;
      }
      final selected = <String, Set<String>>{
        for (final q in questions) q.id: <String>{},
      };
      emit(
        LessonQuizState(
          status: LessonQuizUiStatus.ready,
          questions: questions,
          currentIndex: 0,
          selectedByQuizId: selected,
          revealedByQuizId: const {},
          startedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: LessonQuizUiStatus.failure, message: 'load_failed'));
    }
  }

  void _onOptionToggled(LessonQuizOptionToggled event, Emitter<LessonQuizState> emit) {
    if (state.status != LessonQuizUiStatus.ready) return;
    final q = state.currentQuestion;
    if (q == null) return;
    if (state.isCurrentRevealed) return;

    final next = Map<String, Set<String>>.from(state.selectedByQuizId.map((k, v) => MapEntry(k, Set<String>.from(v))));
    final set = next[q.id] ?? <String>{};
    if (q.type == LessonQuizQuestionType.singleChoice) {
      set
        ..clear()
        ..add(event.optionId);
    } else {
      if (set.contains(event.optionId)) {
        set.remove(event.optionId);
      } else {
        set.add(event.optionId);
      }
    }
    next[q.id] = set;
    emit(state.copyWith(selectedByQuizId: next));
  }

  Future<void> _onPrimaryPressed(LessonQuizPrimaryPressed event, Emitter<LessonQuizState> emit) async {
    if (state.status != LessonQuizUiStatus.ready) return;
    final q = state.currentQuestion;
    if (q == null) return;

    final selected = state.selectedByQuizId[q.id] ?? {};

    if (!state.isCurrentRevealed) {
      if (selected.isEmpty) return;
      emit(state.copyWith(status: LessonQuizUiStatus.checking));
      try {
        final ok = await _repository.checkAnswer(quizId: q.id, selectedOptionIds: selected.toList(growable: false));
        final revealed = Map<String, bool>.from(state.revealedByQuizId)..[q.id] = ok;
        emit(state.copyWith(status: LessonQuizUiStatus.ready, revealedByQuizId: revealed));
      } catch (_) {
        emit(state.copyWith(status: LessonQuizUiStatus.ready, message: 'check_failed'));
      }
      return;
    }

    if (state.currentIndex < state.questions.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1, clearMessage: true));
      return;
    }

    /// Yakunlash: serverga yuborish natija ekranidagi «Davom etish» da (dars yakunlash bilan bog‘liq emas).
    emit(state.copyWith(status: LessonQuizUiStatus.previewResult, clearMessage: true));
  }
}
