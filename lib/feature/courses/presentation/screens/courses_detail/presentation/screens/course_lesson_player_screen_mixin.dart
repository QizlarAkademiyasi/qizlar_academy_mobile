import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'dart:async';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_module_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';

mixin CourseLessonPlayerScreenMixin<T extends StatefulWidget> on State<T> {
  CourseLessonPlayerArgs get args;

  late String _selectedLessonId;
  final Map<String, CourseLessonModel> _hydratedLessons = {};
  final Set<String> _hydratingLessonIds = {};
  bool _isCompleting = false;

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
            isExpandedByDefault: m.isExpandedByDefault,
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
    _selectedLessonId = _resolveInitialLessonId();
    scheduleMicrotask(() => _hydrateLesson(_selectedLessonId));
  }

  void onLessonTap(String lessonId) {
    CourseLessonModel? lesson;
    for (final item in _allLessons) {
      if (item.id == lessonId) {
        lesson = item;
        break;
      }
    }
    if (lesson == null || lesson.isLocked) return;
    Gaimon.light();
    setState(() => _selectedLessonId = lessonId);
    _hydrateLesson(lessonId);
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
    if (target != null && target.hasCompletedLessonQuiz) {
      if (context.mounted) {
        AppToast.info(context, message: context.l10n.lessonQuizAlreadyTaken);
      }
      return;
    }
    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'lesson_quiz_player_$lessonId');
    if (!canOpen || !context.mounted) return;
    final Object? res = await context.push(Routes.lessonQuiz(lessonId));
    if (res is LessonQuizSubmitResultModel) {
      final current = _hydratedLessons[lessonId];
      if (current != null && mounted) {
        setState(() {
          _hydratedLessons[lessonId] = current.copyWith(
            hasQuiz: true,
            isQuizAttempted: true,
            quizPassed: !res.isFail,
            quizCorrectCount: res.correctAnswerCount,
            quizTotalCount: res.totalCount,
          );
        });
      }
    }
    if (mounted) await _hydrateLesson(lessonId, force: true);
  }

  Future<void> _hydrateLesson(String lessonId, {bool force = false}) async {
    if (lessonId.trim().isEmpty) return;
    if (!force && _hydratingLessonIds.contains(lessonId)) return;
    _hydratingLessonIds.add(lessonId);
    try {
      final lesson = await getIt<CoursesRepository>().fetchLessonDetails(
        lessonId: lessonId,
        courseId: args.course.id,
      );
      if (!mounted) return;
      final previous = _hydratedLessons[lessonId];
      final merged = previous != null && previous.isCompleted && !lesson.isCompleted
          ? lesson.copyWith(isCompleted: true)
          : lesson;
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
    final rawUrl = lesson.videoUrl;
    final uri = rawUrl == null ? null : Uri.tryParse(rawUrl);

    if (uri == null) {
      return Container(
        color: context.appColors.onContainer,
        alignment: Alignment.center,
        child: Icon(LucideIcons.videoOff, color: context.appColors.grey, size: 28),
      );
    }

    return OmniVideoPlayer(
      key: ValueKey<String>('lesson_player_${lesson.id}'),
      configuration: VideoPlayerConfiguration(videoSourceConfiguration: _videoSourceFor(uri)),
      callbacks: VideoPlayerCallbacks(
        onFinished: () {
          Future.microtask(() => onCurrentLessonPlaybackFinished());
        },
      ),
    );
  }

  String _resolveInitialLessonId() {
    if (args.initialLessonId != null && args.initialLessonId!.isNotEmpty) {
      return args.initialLessonId!;
    }

    for (final lesson in _allLessons) {
      if (!lesson.isLocked && !lesson.isCompleted) return lesson.id;
    }
    for (final lesson in _allLessons) {
      if (!lesson.isLocked) return lesson.id;
    }
    return _allLessons.isNotEmpty ? _allLessons.first.id : '';
  }

  VideoSourceConfiguration _videoSourceFor(Uri uri) {
    final host = uri.host.toLowerCase();
    final isYoutube = host.contains('youtube.com') || host.contains('youtu.be');
    if (isYoutube) {
      return VideoSourceConfiguration.youtube(videoUrl: uri).copyWith(autoPlay: true);
    }

    return VideoSourceConfiguration.network(videoUrl: uri).copyWith(autoPlay: true);
  }
}
