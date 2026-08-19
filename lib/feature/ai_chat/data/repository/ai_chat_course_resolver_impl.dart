import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_course_resolver.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';

class AiChatCourseResolverImpl implements AiChatCourseResolver {
  AiChatCourseResolverImpl({
    required HomeRepository homeRepository,
    required CoursesCatalogRepository catalogRepository,
    required CoursesRepository coursesRepository,
  }) : _homeRepository = homeRepository,
       _catalogRepository = catalogRepository,
       _coursesRepository = coursesRepository;

  final HomeRepository _homeRepository;
  final CoursesCatalogRepository _catalogRepository;
  final CoursesRepository _coursesRepository;

  final Map<String, AiChatCourseModel> _memory = {};
  final Map<String, AiChatCourseModel> _homeById = {};
  final Map<String, AiChatCourseModel> _catalogById = {};
  var _homeLoaded = false;
  var _catalogLoaded = false;

  @override
  void remember(Iterable<AiChatCourseModel> courses) {
    for (final course in courses) {
      final mapped = _validOrNull(course);
      if (mapped != null) _memory[mapped.id] = mapped;
    }
  }

  @override
  Future<List<AiChatCourseModel>> resolve(List<String> ids) async {
    final unique = ids
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
    if (unique.isEmpty) return const [];

    final found = <String, AiChatCourseModel>{};
    for (final id in unique) {
      final cached = _memory[id];
      if (cached != null) found[id] = cached;
    }

    var missing = _missing(unique, found);
    if (missing.isEmpty) return _ordered(unique, found);

    await _ensureHome();
    _fillFrom(_homeById, missing, found);
    missing = _missing(unique, found);
    if (missing.isEmpty) return _ordered(unique, found);

    await _ensureCatalog();
    _fillFrom(_catalogById, missing, found);
    missing = _missing(unique, found);
    if (missing.isEmpty) return _ordered(unique, found);

    await _fetchDetails(missing, found);
    return _ordered(unique, found);
  }

  Future<void> _ensureHome() async {
    if (_homeLoaded) return;
    try {
      final courses = await _homeRepository.getCourses();
      _homeLoaded = true;
      for (final course in courses) {
        final mapped = _fromHome(course);
        if (mapped != null) _homeById[mapped.id] = mapped;
      }
    } catch (error, stackTrace) {
      AppLogger.w(
        'AiChatCourseResolver: home courses failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _ensureCatalog() async {
    if (_catalogLoaded) return;
    try {
      final overview = await _catalogRepository.fetchCatalog(query: '');
      _catalogLoaded = true;
      for (final course in overview.courses) {
        final mapped = _fromCatalog(course);
        if (mapped != null) _catalogById[mapped.id] = mapped;
      }
    } catch (error, stackTrace) {
      AppLogger.w(
        'AiChatCourseResolver: catalog courses failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _fetchDetails(
    List<String> ids,
    Map<String, AiChatCourseModel> found,
  ) async {
    await Future.wait(
      ids.map((id) async {
        try {
          final details = await _coursesRepository.fetchCourseDetails(
            courseId: id,
          );
          final mapped = _fromDetails(details);
          if (mapped == null) return;
          found[id] = mapped;
          _memory[id] = mapped;
        } catch (error, stackTrace) {
          AppLogger.w(
            'AiChatCourseResolver: course $id failed',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }),
    );
  }

  void _fillFrom(
    Map<String, AiChatCourseModel> source,
    List<String> missing,
    Map<String, AiChatCourseModel> found,
  ) {
    for (final id in missing) {
      final course = source[id];
      if (course == null) continue;
      found[id] = course;
      _memory[id] = course;
    }
  }

  List<String> _missing(
    List<String> ids,
    Map<String, AiChatCourseModel> found,
  ) {
    return ids.where((id) => !found.containsKey(id)).toList(growable: false);
  }

  List<AiChatCourseModel> _ordered(
    List<String> ids,
    Map<String, AiChatCourseModel> found,
  ) {
    return [
      for (final id in ids)
        if (found[id] != null) found[id]!,
    ];
  }

  AiChatCourseModel? _fromHome(CourseModel course) {
    return _validOrNull(
      AiChatCourseModel(
        id: course.id.trim(),
        title: course.title.trim(),
        mentorName: course.author.trim(),
        imageUrl: course.imageUrl,
        durationMinutes: _minutesFromHomeDuration(course.durationSeconds),
        studentCount: course.studentCount > 0 ? course.studentCount : null,
      ),
    );
  }

  AiChatCourseModel? _fromCatalog(CourseCatalogItemModel course) {
    return _validOrNull(
      AiChatCourseModel(
        id: course.id.trim(),
        title: course.title.trim(),
        mentorName: course.mentorName.trim(),
        imageUrl: course.imageUrl,
        rating: course.rating > 0 ? course.rating : null,
        totalRatings: course.reviewsCount > 0 ? course.reviewsCount : null,
        durationMinutes: _minutesFromHomeDuration(course.durationSeconds),
      ),
    );
  }

  AiChatCourseModel? _fromDetails(CourseDetailsModel course) {
    return _validOrNull(
      AiChatCourseModel(
        id: course.id.trim(),
        title: course.title.trim(),
        mentorName: course.teacherName.trim(),
        imageUrl: course.coverImageUrl,
        rating: course.rating > 0 ? course.rating : null,
        totalRatings: course.reviewsCount > 0 ? course.reviewsCount : null,
        lessonCount: course.lessonsCount > 0 ? course.lessonsCount : null,
        studentCount: course.studentsCount > 0 ? course.studentsCount : null,
      ),
    );
  }

  AiChatCourseModel? _validOrNull(AiChatCourseModel course) {
    if (course.id.isEmpty || course.title.isEmpty) return null;
    return course;
  }

  static int? _minutesFromHomeDuration(int durationSeconds) {
    if (durationSeconds <= 0) return null;
    final minutes = durationSeconds ~/ 60;
    return minutes > 0 ? minutes : null;
  }
}
