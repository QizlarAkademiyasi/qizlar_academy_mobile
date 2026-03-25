import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_lesson_player_args.dart';

mixin CourseLessonPlayerScreenMixin<T extends StatefulWidget> on State<T> {
  CourseLessonPlayerArgs get args;

  late String _selectedLessonId;

  List<CourseLessonModel> get _allLessons =>
      args.course.modules.expand((m) => m.lessons).toList();

  CourseLessonModel? get selectedLesson {
    for (final lesson in _allLessons) {
      if (lesson.id == _selectedLessonId) return lesson;
    }
    return _allLessons.isNotEmpty ? _allLessons.first : null;
  }

  @override
  void initState() {
    super.initState();
    _selectedLessonId = _resolveInitialLessonId();
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
  }

  Widget buildVideoPlayer(
    BuildContext context, {
    required CourseLessonModel lesson,
  }) {
    final rawUrl = lesson.videoUrl;
    final uri = rawUrl == null ? null : Uri.tryParse(rawUrl);

    if (uri == null) {
      return Container(
        color: context.appColors.onContainer,
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.videoOff,
          color: context.appColors.grey,
          size: 28,
        ),
      );
    }

    return OmniVideoPlayer(
      key: ValueKey<String>('lesson_player_${lesson.id}'),
      configuration: VideoPlayerConfiguration(
        videoSourceConfiguration: _videoSourceFor(uri),
      ),
      callbacks: const VideoPlayerCallbacks(),
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
      return VideoSourceConfiguration.youtube(videoUrl: uri).copyWith(
        autoPlay: true,
      );
    }

    return VideoSourceConfiguration.network(videoUrl: uri).copyWith(
      autoPlay: true,
    );
  }
}
