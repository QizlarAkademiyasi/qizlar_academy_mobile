import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/lesson_quiz_already_submitted_exception.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/lesson_quiz_bloc.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/helpers/course_certificate_after_quiz_helper.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_launch_context.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_result_args.dart';

mixin LessonQuizScreenMixin<T extends StatefulWidget> on State<T> {
  DateTime? _quizDeadline;
  Timer? _quizTicker;

  /// Oxirgi savoldan keyin avtomatik submit bir marta ishlashi uchun.
  bool _lessonQuizAutoSubmitScheduled = false;

  @override
  void dispose() {
    _quizTicker?.cancel();
    super.dispose();
  }

  void lessonQuizStateListener(BuildContext context, LessonQuizState prev, LessonQuizState next) {
    if (prev.status == LessonQuizUiStatus.loading && next.status == LessonQuizUiStatus.ready) {
      _lessonQuizAutoSubmitScheduled = false;
    }

    if (prev.status != LessonQuizUiStatus.ready && next.status == LessonQuizUiStatus.ready) {
      _quizDeadline ??= DateTime.now().add(const Duration(minutes: 30));
      _quizTicker ??= Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (mounted) setState(() {});
      });
    }

    if (next.status == LessonQuizUiStatus.previewResult && next.startedAt != null && next.questions.isNotEmpty) {
      if (_lessonQuizAutoSubmitScheduled) return;
      _lessonQuizAutoSubmitScheduled = true;
      _quizTicker?.cancel();
      _quizTicker = null;
      final elapsed = DateTime.now().difference(next.startedAt!);
      final correct = next.revealedByQuizId.values.where((v) => v).length;
      final total = next.questions.length;
      final answers = next.questions.map((qq) => LessonQuizAnswerPayload(quizId: qq.id, selectedOptionIds: (next.selectedByQuizId[qq.id] ?? {}).toList(growable: false))).toList(growable: false);
      final preview = LessonQuizSubmitResultModel(correctAnswerCount: correct, totalCount: total <= 0 ? 1 : total, isFail: total > 0 && correct * 2 < total);
      final lessonId = context.read<LessonQuizBloc>().lessonId;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        var resultToShow = preview;
        var pendingSubmit = false;
        try {
          resultToShow = await getIt<LessonQuizRepository>().submitLessonQuiz(lessonId: lessonId, answers: answers);
          getIt<LessonQuizRepository>().clearCacheForLesson(lessonId);
        } on LessonQuizAlreadySubmittedException {
          if (context.mounted) {
            AppToast.info(context, message: context.l10n.lessonQuizAlreadyTaken);
          }
        } catch (_) {
          if (context.mounted) {
            AppToast.error(context, message: context.l10n.lessonQuizErrorSubmit);
          }
          pendingSubmit = true;
        }
        if (!context.mounted) return;
        final res = await context.push(
          Routes.lessonQuizResult,
          extra: LessonQuizResultArgs(result: resultToShow, elapsed: elapsed, pendingSubmit: pendingSubmit, lessonId: lessonId, answers: answers),
        );
        if (!context.mounted) return;
        if (res == LessonQuizResultOutcome.retry) {
          context.read<LessonQuizBloc>().add(const LessonQuizRestartRequested());
          return;
        }
        if (res is LessonQuizSubmitResultModel && !res.isFail) {
          final launch = LessonQuizLaunchScope.maybeOf(context);
          if (launch != null && launch.requestCertificateOnPass && launch.courseId.trim().isNotEmpty) {
            await showCourseCertificateAfterTerminalQuiz(context, courseId: launch.courseId, courseName: launch.courseName);
          }
        }
        if (context.mounted) context.pop(res);
      });
    }

    if (prev.status != LessonQuizUiStatus.failure && next.status == LessonQuizUiStatus.failure && next.message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        AppToast.error(context, message: _mapQuizMessage(context, next.message!));
        if (next.message == 'empty_quiz' || next.message == 'load_failed') {
          context.pop();
        }
      });
    }

    if (prev.message != next.message && next.message == 'check_failed' && next.status == LessonQuizUiStatus.ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        AppToast.error(context, message: _mapQuizMessage(context, 'check_failed'));
      });
    }
  }

  String _mapQuizMessage(BuildContext context, String code) {
    final l10n = context.l10n;
    switch (code) {
      case 'empty_quiz':
        return l10n.lessonQuizErrorEmpty;
      case 'load_failed':
        return l10n.lessonQuizErrorLoad;
      case 'check_failed':
        return l10n.lessonQuizErrorCheck;
      default:
        return l10n.lessonQuizErrorGeneric;
    }
  }

  String? formattedQuizCountdown() {
    final end = _quizDeadline;
    if (end == null) return null;
    var left = end.difference(DateTime.now());
    if (left.isNegative) left = Duration.zero;
    final totalSeconds = left.inSeconds;
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
