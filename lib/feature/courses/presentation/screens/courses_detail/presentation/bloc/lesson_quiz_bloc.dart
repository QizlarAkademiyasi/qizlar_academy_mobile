import 'dart:math';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';

part 'lesson_quiz_event.dart';
part 'lesson_quiz_state.dart';

class LessonQuizBloc extends Bloc<LessonQuizEvent, LessonQuizState> {
  LessonQuizBloc(this._repository, {required this.lessonId}) : super(const LessonQuizState()) {
    on<LessonQuizStarted>(_onStarted);
    on<LessonQuizOptionToggled>(_onOptionToggled);
    on<LessonQuizSingleOptionChosen>(_onSingleOptionChosen);
    on<LessonQuizPrimaryPressed>(_onPrimaryPressed);
    on<LessonQuizRestartRequested>(_onRestart);
  }

  static const Duration _revealAdvanceDelay = Duration(milliseconds: 1500);

  final LessonQuizRepository _repository;
  final String lessonId;

  Future<void> _onStarted(LessonQuizStarted event, Emitter<LessonQuizState> emit) async {
    emit(state.copyWith(status: LessonQuizUiStatus.loading, clearMessage: true));
    try {
      final fetched = await _repository.fetchQuestionsForLesson(lessonId);
      if (fetched.isEmpty) {
        emit(state.copyWith(status: LessonQuizUiStatus.failure, message: 'empty_quiz'));
        return;
      }
      final questions = _shuffleQuizQuestionsForDisplay(fetched);
      final selected = <String, Set<String>>{for (final q in questions) q.id: <String>{}};
      emit(LessonQuizState(status: LessonQuizUiStatus.ready, questions: questions, currentIndex: 0, selectedByQuizId: selected, revealedByQuizId: const {}, startedAt: DateTime.now()));
    } catch (_) {
      emit(state.copyWith(status: LessonQuizUiStatus.failure, message: 'load_failed'));
    }
  }

  Future<void> _onRestart(LessonQuizRestartRequested event, Emitter<LessonQuizState> emit) async {
    emit(state.copyWith(status: LessonQuizUiStatus.loading, clearMessage: true));
    try {
      _repository.clearCacheForLesson(lessonId);
      final fetched = await _repository.fetchQuestionsForLesson(lessonId);
      if (fetched.isEmpty) {
        emit(state.copyWith(status: LessonQuizUiStatus.failure, message: 'empty_quiz'));
        return;
      }
      final questions = _shuffleQuizQuestionsForDisplay(fetched);
      final selected = <String, Set<String>>{for (final q in questions) q.id: <String>{}};
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
    if (q.type == LessonQuizQuestionType.singleChoice) return;
    if (state.isCurrentRevealed) return;

    final next = Map<String, Set<String>>.from(state.selectedByQuizId.map((k, v) => MapEntry(k, Set<String>.from(v))));
    final set = next[q.id] ?? <String>{};
    if (set.contains(event.optionId)) {
      set.remove(event.optionId);
    } else {
      set.add(event.optionId);
    }
    next[q.id] = set;
    emit(state.copyWith(selectedByQuizId: next));
  }

  Future<void> _onSingleOptionChosen(LessonQuizSingleOptionChosen event, Emitter<LessonQuizState> emit) async {
    if (state.status != LessonQuizUiStatus.ready) return;
    final q = state.currentQuestion;
    if (q == null) return;
    if (q.type != LessonQuizQuestionType.singleChoice) return;
    if (state.isCurrentRevealed) return;

    final next = Map<String, Set<String>>.from(state.selectedByQuizId.map((k, v) => MapEntry(k, Set<String>.from(v))));
    next[q.id] = {event.optionId};
    emit(state.copyWith(selectedByQuizId: next));
    await _checkRevealAndAdvanceAfterDelay(emit, quizId: q.id, selectedIds: [event.optionId]);
  }

  Future<void> _onPrimaryPressed(LessonQuizPrimaryPressed event, Emitter<LessonQuizState> emit) async {
    if (state.status != LessonQuizUiStatus.ready) return;
    final q = state.currentQuestion;
    if (q == null) return;
    if (q.type != LessonQuizQuestionType.multipleChoice) return;
    if (state.isCurrentRevealed) return;

    final selected = state.selectedByQuizId[q.id] ?? {};
    if (selected.isEmpty) return;
    await _checkRevealAndAdvanceAfterDelay(emit, quizId: q.id, selectedIds: selected.toList(growable: false));
  }

  Future<void> _checkRevealAndAdvanceAfterDelay(Emitter<LessonQuizState> emit, {required String quizId, required List<String> selectedIds}) async {
    emit(state.copyWith(status: LessonQuizUiStatus.checking, clearMessage: true));
    final qIndex = state.questions.indexWhere((q) => q.id == quizId);
    if (qIndex < 0) {
      if (isClosed) return;
      emit(state.copyWith(status: LessonQuizUiStatus.ready, message: 'check_failed'));
      return;
    }
    final ok = state.questions[qIndex].isSelectionCorrect(selectedIds);
    if (isClosed) return;
    final revealed = Map<String, bool>.from(state.revealedByQuizId)..[quizId] = ok;
    emit(state.copyWith(status: LessonQuizUiStatus.ready, revealedByQuizId: revealed, clearMessage: true));

    await Future<void>.delayed(_revealAdvanceDelay);
    if (isClosed) return;

    if (state.currentIndex < state.questions.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1, clearMessage: true));
    } else {
      emit(state.copyWith(status: LessonQuizUiStatus.previewResult, clearMessage: true));
    }
  }
}

List<LessonQuizQuestionModel> _shuffleQuizQuestionsForDisplay(List<LessonQuizQuestionModel> source) {
  final rng = Random();
  final withShuffledOptions = source
      .map(
        (q) => LessonQuizQuestionModel(
          id: q.id,
          type: q.type,
          mediaType: q.mediaType,
          question: q.question,
          options: List<LessonQuizOptionModel>.from(q.options)..shuffle(rng),
        ),
      )
      .toList();
  withShuffledOptions.shuffle(rng);
  return withShuffledOptions;
}
