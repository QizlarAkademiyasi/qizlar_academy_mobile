import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'dart:async';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/course_curriculum_progress.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_module_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/course_details_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_complete_congrats_dialog.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_lesson_video_player.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_launch_context.dart';

mixin CourseLessonPlayerScreenMixin<T extends StatefulWidget> on State<T> {
  CourseLessonPlayerArgs get args;

  late String _selectedLessonId;
  final Map<String, CourseLessonModel> _hydratedLessons = {};
  final Set<String> _hydratingLessonIds = {};
  bool _isCompleting = false;
  late bool _initialCurriculumComplete;
  bool _courseCompleteDialogShown = false;

  List<CourseLessonModel> get _allLessons => args.course.modules.expand((m) => m.lessons).toList();

  /// Ro‘yxat va test qatorlari `_hydratedLessons` bilan yangilanadi (course args o‘zgarmaydi).
  List<CourseModuleModel> get modulesWithHydratedLessons {
    return args.course.modules
        .map(
          (m) => CourseModuleModel(
            id: m.id,
            title: m.title,
            progressText: m.progressText,
            totalDurationText: m.totalDurationText,
            isExpandedByDefault: m.lessons.any((l) => l.id == _selectedLessonId),
            lessons: m.lessons.map(_mergeHydrated).toList(growable: false),
          ),
        )
        .toList(growable: false);
  }

  CourseLessonModel? get selectedLesson {
    for (final lesson in _allLessons) {
      if (lesson.id == _selectedLessonId) {
        return _mergeHydrated(lesson);
      }
    }
    return _allLessons.isNotEmpty ? _mergeHydrated(_allLessons.first) : null;
  }

  @override
  void initState() {
    super.initState();
    _initialCurriculumComplete = CourseCurriculumProgress.isCourseFullyComplete(args.course.modules);
    _selectedLessonId = _resolveInitialLessonId();
    scheduleMicrotask(() => _hydrateLesson(_selectedLessonId));
  }

  void _maybeAnnounceCourseComplete() {
    if (!mounted) return;
    if (!args.course.isEnrolled || !isRegistered) return;
    if (_initialCurriculumComplete || _courseCompleteDialogShown) return;
    if (!CourseCurriculumProgress.isCourseFullyComplete(modulesWithHydratedLessons)) return;
    if (CourseCurriculumProgress.courseFinishedWithTerminalLessonQuiz(modulesWithHydratedLessons)) return;
    _courseCompleteDialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showCourseCompleteCongratsDialog(context);
    });
  }

  void onLessonTap(BuildContext context, String lessonId) {
    CourseLessonModel? lesson;
    for (final item in _allLessons) {
      if (item.id == lessonId) {
        lesson = item;
        break;
      }
    }
    if (lesson == null || lesson.isLocked) return;
    if (args.course.isEnrolled && isRegistered) {
      if (!CourseCurriculumProgress.canAccessLesson(modulesWithHydratedLessons, lessonId)) {
        AppToast.info(context, message: context.l10n.courseLessonSequentialLockedMessage);
        return;
      }
    }
    Gaimon.light();
    setState(() => _selectedLessonId = lessonId);
    _hydrateLesson(lessonId);
  }

  /// Jadval tartibida keyingi darsni mahalliy state’da ochish (submit `isFail: false`).
  void _unlockNextLessonInHydration(String completedLessonId) {
    final flat = _allLessons;
    final idx = flat.indexWhere((l) => l.id == completedLessonId);
    if (idx < 0 || idx >= flat.length - 1) return;
    final nextBase = flat[idx + 1];
    final merged = _mergeHydrated(nextBase);
    _hydratedLessons[nextBase.id] = merged.copyWith(isLocked: false);
  }

  String? _lessonIdAfter(String lessonId) {
    final flat = _allLessons;
    final idx = flat.indexWhere((l) => l.id == lessonId);
    if (idx < 0 || idx >= flat.length - 1) return null;
    return flat[idx + 1].id;
  }

  CourseLessonModel _mergeHydrated(CourseLessonModel base) {
    final hydrated = _hydratedLessons[base.id];
    if (hydrated == null) return base;
    return base.copyWith(
      title: hydrated.title,
      order: hydrated.order,
      duration: hydrated.duration,
      videoUrl: hydrated.videoUrl,
      isLocked: hydrated.isLocked,
      isCompleted: hydrated.isCompleted,
      quizPassed: hydrated.quizPassed,
      quizCorrectCount: hydrated.quizCorrectCount,
      quizTotalCount: hydrated.quizTotalCount,
      hasQuiz: hydrated.hasQuiz,
      isQuizAttempted: hydrated.isQuizAttempted,
    );
  }

  Future<void> openLessonQuizFromPlayer(BuildContext context, {required String lessonId}) async {
    CourseLessonModel? target;
    for (final l in _allLessons) {
      if (l.id == lessonId) {
        target = _mergeHydrated(l);
        break;
      }
    }
    if (target != null && target.quizPassed) {
      if (context.mounted) {
        AppToast.info(context, message: context.l10n.lessonQuizAlreadyTaken);
      }
      return;
    }
    if (args.course.isEnrolled && isRegistered) {
      if (!CourseCurriculumProgress.canAccessLesson(modulesWithHydratedLessons, lessonId)) {
        if (context.mounted) {
          AppToast.info(context, message: context.l10n.courseLessonSequentialLockedMessage);
        }
        return;
      }
    }
    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'lesson_quiz_player_$lessonId');
    if (!canOpen || !context.mounted) return;
    final terminalId = CourseCurriculumProgress.terminalLessonId(args.course.modules);
    final isTerminal = terminalId != null && terminalId == lessonId;
    final requestCert = args.course.isEnrolled && isRegistered && isTerminal && (target?.hasQuiz ?? false);
    final launch = LessonQuizLaunchContext(courseId: args.course.id, courseName: args.course.title, requestCertificateOnPass: requestCert);
    final Object? res = await context.push(Routes.lessonQuiz(lessonId), extra: launch);
    if (!context.mounted) return;
    if (mounted) await _hydrateLesson(lessonId, force: true);
    if (!context.mounted) return;
    if (res is LessonQuizSubmitResultModel) {
      CourseLessonModel? baseForLesson;
      for (final l in _allLessons) {
        if (l.id == lessonId) {
          baseForLesson = l;
          break;
        }
      }
      String? nextLessonId;
      if (baseForLesson != null && mounted) {
        setState(() {
          final current = _hydratedLessons[lessonId] ?? baseForLesson!;
          _hydratedLessons[lessonId] = current.copyWith(hasQuiz: true, isQuizAttempted: true, quizPassed: !res.isFail, quizCorrectCount: res.correctAnswerCount, quizTotalCount: res.totalCount);
          if (!res.isFail) {
            _unlockNextLessonInHydration(lessonId);
            nextLessonId = _lessonIdAfter(lessonId);
            if (nextLessonId != null) {
              _selectedLessonId = nextLessonId!;
            }
          }
        });
      }
      if (!res.isFail && nextLessonId != null && mounted) {
        await _hydrateLesson(nextLessonId!, force: true);
      }
      if (context.mounted) {
        try {
          final bloc = context.read<CourseDetailsBloc>();
          final courseId = args.course.id.trim();
          if (courseId.isNotEmpty && bloc.state.course?.id == courseId) {
            bloc.add(CoursesQuizSubmitted(lessonId: lessonId, result: res));
          }
        } catch (_) {}
      }
    }
    if (mounted) _maybeAnnounceCourseComplete();
  }

  Future<void> _hydrateLesson(String lessonId, {bool force = false}) async {
    if (lessonId.trim().isEmpty) return;
    if (!force && _hydratingLessonIds.contains(lessonId)) return;
    _hydratingLessonIds.add(lessonId);
    try {
      final lesson = await getIt<CoursesRepository>().fetchLessonDetails(lessonId: lessonId, courseId: args.course.id);
      if (!mounted) return;
      final previous = _hydratedLessons[lessonId];
      final merged = previous != null && previous.isCompleted && !lesson.isCompleted ? lesson.copyWith(isCompleted: true) : lesson;
      setState(() => _hydratedLessons[lessonId] = merged);
    } catch (_) {
      // no-op: keep base lesson data, player will show placeholder
    } finally {
      _hydratingLessonIds.remove(lessonId);
    }
  }

  bool get isRegistered => getIt<AuthSessionCubit>().state.isRegistered;

  bool get isCompleting => _isCompleting;

  Future<void> completeSelectedLesson() async {
    final lesson = selectedLesson;
    if (lesson == null) return;
    if (!isRegistered || lesson.isCompleted) return;
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    try {
      await getIt<CoursesRepository>().completeLesson(lessonId: lesson.id);
      if (!mounted) return;
      // Darhol test qatorini ochish: API hydrate kechiksa ham `CourseQuizTile` `isCompleted` ni ko‘radi.
      final current = _hydratedLessons[lesson.id] ?? lesson;
      setState(() => _hydratedLessons[lesson.id] = current.copyWith(isCompleted: true));
      await _hydrateLesson(lesson.id, force: true);
      if (mounted) _maybeAnnounceCourseComplete();
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  /// Video oxirigacha ko‘rilganda: PATCH complete + `course/.../module/{lesson}` orqali kartani yangilash.
  Future<void> onCurrentLessonPlaybackFinished() async {
    if (!mounted) return;
    if (!isRegistered) return;
    final lesson = selectedLesson;
    if (lesson == null || lesson.isCompleted) return;
    if (_isCompleting) return;
    await completeSelectedLesson();
  }

  Widget buildVideoPlayer(BuildContext context, {required CourseLessonModel lesson}) {
    return CourseLessonVideoPlayer(lessonId: lesson.id, videoUrl: lesson.videoUrl, onPlaybackFinished: onCurrentLessonPlaybackFinished);
  }

  String _resolveInitialLessonId() {
    final modules = args.course.modules;
    final gating = args.course.isEnrolled && isRegistered;

    bool canPick(CourseLessonModel l) {
      if (l.isLocked) return false;
      if (gating && !CourseCurriculumProgress.canAccessLesson(modules, l.id)) return false;
      return true;
    }

    final requested = args.initialLessonId?.trim();
    if (requested != null && requested.isNotEmpty) {
      for (final l in _allLessons) {
        if (l.id == requested && canPick(l)) return requested;
      }
    }

    for (final lesson in _allLessons) {
      if (canPick(lesson) && !lesson.isCompleted) return lesson.id;
    }
    for (final lesson in _allLessons) {
      if (canPick(lesson)) return lesson.id;
    }
    return _allLessons.isNotEmpty ? _allLessons.first.id : '';
  }
}
