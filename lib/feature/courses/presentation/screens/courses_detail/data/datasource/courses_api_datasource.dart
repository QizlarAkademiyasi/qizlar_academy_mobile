import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/datasource/courses_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_module_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_review_model.dart';

class CoursesApiDatasource implements CoursesDatasource {
  const CoursesApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId}) async {
    // Backwards compatible default (registered user).
    return fetchCourseDetailsByUserType(courseId: courseId, userType: UserType.user);
  }

  Future<CourseDetailsModel> fetchCourseDetailsByUserType({required String courseId, required UserType userType}) async {
    final path = userType == UserType.guest ? AnonymousApis.courseModulesByCourseIdPublic(courseId) : UserApis.courseModulesByCourseId(courseId);

    final response = await _dio.get<dynamic>(path);
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);

    final teacher = _asMap(data['teacher']);
    final totalDurationSeconds = _parseInt(data['totalDuration']);
    final modulesRaw = _asList(data['modules']);
    var lessonsCount = _parseInt(data['lessonCount']);
    if (lessonsCount <= 0) {
      lessonsCount = modulesRaw.fold<int>(0, (sum, m) => sum + _asList(m['lessons']).length);
    }
    final completedLessonCount = _parseInt(data['completedLessonCount']);

    final modules = modulesRaw
        .map((moduleRaw) {
          final lessons = _asList(moduleRaw['lessons']).map((lessonRaw) => _parseLessonMap(lessonRaw, userType)).toList(growable: false);

          final completedInModule = lessons.where((l) => l.isCompleted).length;
          final moduleDurationSeconds = lessons.fold<int>(0, (sum, l) => sum + _parseDurationFromLabel(l.duration));
          final progressText = userType == UserType.user
              ? '$completedInModule/${lessons.length} dars · ${_formatDurationCompact(moduleDurationSeconds)}'
              : '${lessons.length} dars · ${_formatDurationCompact(moduleDurationSeconds)}';

          return CourseModuleModel(
            id: (moduleRaw['id'] ?? '').toString(),
            title: (moduleRaw['name'] ?? '').toString(),
            progressText: progressText,
            totalDurationText: _formatDurationCompact(moduleDurationSeconds),
            lessons: lessons,
            isExpandedByDefault: true,
          );
        })
        .toList(growable: false);

    final progressRatio = userType == UserType.user && lessonsCount > 0 ? (completedLessonCount / lessonsCount).clamp(0.0, 1.0).toDouble() : 0.0;

    final categoryMap = _asMapOrNull(data['category']);
    final categoryName = [
      (data['categoryName'] ?? '').toString(),
      (data['category_name'] ?? '').toString(),
      (categoryMap?['name'] ?? '').toString(),
      (data['subject'] ?? '').toString(),
    ].map((s) => s.trim()).firstWhere((s) => s.isNotEmpty, orElse: () => '');

    final isEnrolled = _parseIsEnrolled(data, userType: userType);
    final teacherRole = [
      (teacher['role'] ?? '').toString(),
      (teacher['title'] ?? '').toString(),
      (teacher['position'] ?? '').toString(),
      (data['teacherRole'] ?? '').toString(),
    ].map((s) => s.trim()).firstWhere((s) => s.isNotEmpty, orElse: () => '');

    final courseTitle = (data['name'] ?? '').toString();

    final reviewsCountApi = _parseInt(data['totalRatings']);
    final reviewsList = _parseCourseReviews(data['reviews'] ?? data['courseReviews'] ?? data['course_reviews'] ?? data['comments'] ?? data['feedbacks']);
    var ratingBreakdown = _mergeRatingBreakdownRows(
      _parseRatingBreakdown(
        data['ratingBreakdown'] ?? data['rating_breakdown'] ?? data['ratingsBreakdown'] ?? data['ratingDistribution'] ?? data['ratings'] ?? data['ratingStats'],
        totalReviewCount: reviewsCountApi > 0 ? reviewsCountApi : reviewsList.length,
      ),
    );
    final hasNonZeroBreakdown = ratingBreakdown.any((r) => r.percent > 0);
    if (!hasNonZeroBreakdown && reviewsList.isNotEmpty) {
      ratingBreakdown = _ratingBreakdownFromReviews(reviewsList);
    }

    return CourseDetailsModel(
      id: (data['id'] ?? courseId).toString(),
      title: courseTitle,
      categoryName: categoryName,
      isEnrolled: isEnrolled,
      teacherName: (teacher['fullname'] ?? '').toString(),
      teacherRole: teacherRole.isNotEmpty ? teacherRole : courseTitle,
      coverImageUrl: Apis.resolveUrl((data['icon']).toString()),
      teacherAvatarUrl: Apis.resolveUrl((teacher['photo'] ?? '').toString()),
      rating: _parseDouble(data['avgRating']),
      reviewsCount: _parseInt(data['totalRatings']),
      studentsCount: _parseInt(data['enrollmentCount']),
      totalDurationText: _formatDurationCompact(totalDurationSeconds),
      lessonsCount: lessonsCount,
      progressRatio: progressRatio,
      progressLessonsText: userType == UserType.user ? '$completedLessonCount/$lessonsCount dars' : '',
      progressSeenText: userType == UserType.user ? '$completedLessonCount ta dars ko‘rilgan' : '',
      progressDurationText: _formatDurationCompact(totalDurationSeconds),
      description: (data['description'] ?? data['shortDescription'] ?? '').toString(),
      teacherDescription: '',
      ratingBreakdown: ratingBreakdown,
      reviews: reviewsList,
      modules: modules,
    );
  }

  Future<CourseLessonModel> fetchLessonDetailsByUserType({
    required String lessonId,
    required UserType userType,
    String? courseId,
  }) async {
    final cid = courseId?.trim() ?? '';
    if (userType == UserType.user && cid.isNotEmpty) {
      try {
        final response = await _dio.get<dynamic>(UserApis.courseModuleById(courseId: cid, moduleId: lessonId));
        final envelope = _asMap(response.data);
        final lessonData = _asMap(envelope['data']);
        if (lessonData.isNotEmpty) {
          return _parseLessonMap(lessonData, userType, fallbackLessonId: lessonId);
        }
      } catch (_) {
        // Eski `/lesson/{id}/client` ga tushamiz.
      }
    }

    final path = userType == UserType.guest ? AnonymousApis.lessonByIdClientPublic(lessonId) : UserApis.lessonByIdClient(lessonId);

    final response = await _dio.get<dynamic>(path);
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);

    return _parseLessonMap(data, userType, fallbackLessonId: lessonId);
  }

  Future<void> completeLesson({required String lessonId}) async {
    await _dio.patch<dynamic>(UserApis.lessonCompleteById(lessonId));
  }

  Future<void> enrollInCourse({required String courseId}) async {
    await _dio.post<void>(
      UserApis.courseEnrollById(courseId),
      options: Options(responseType: ResponseType.plain, validateStatus: (status) => status != null && status >= 200 && status < 300),
    );
  }

  Future<void> submitCourseRating({required String courseId, required double rating, required String comment}) async {
    await _dio.post<dynamic>(
      UserApis.courseRating,
      data: <String, dynamic>{
        'courseId': courseId,
        'rating': rating,
        'comment': comment,
      },
    );
  }

  /// `GET /api/v1/course-rating/course/{courseId}` — sharhlar ro‘yxati.
  Future<List<CourseReviewModel>> fetchCourseRatingsForCourse({required String courseId}) async {
    final response = await _dio.get<dynamic>(UserApis.courseRatingsByCourseId(courseId));
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    var listRaw = data['data'];
    if (listRaw == null && envelope['data'] is List) {
      listRaw = envelope['data'];
    }
    return _parseCourseReviews(listRaw);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map(_asMap).toList(growable: false);
  }

  Map<String, dynamic>? _asMapOrNull(dynamic value) {
    final m = _asMap(value);
    return m.isEmpty ? null : m;
  }

  bool _parseIsEnrolled(Map<String, dynamic> data, {required UserType userType}) {
    final raw = data['isEnrolled'] ?? data['is_enrolled'] ?? data['enrolled'] ?? data['isSubscribed'] ?? data['hasEnrolled'];
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    if (raw is String) {
      final s = raw.trim().toLowerCase();
      if (s == 'true' || s == '1' || s == 'yes') return true;
      if (s == 'false' || s == '0' || s == 'no') return false;
    }
    return false;
  }

  int _parseInt(dynamic value) => int.tryParse('${value ?? 0}') ?? 0;

  int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse('$value');
  }

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final s = value.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  bool _parseHasQuiz(Map<String, dynamic> raw) {
    if (raw.containsKey('hasQuiz')) return raw['hasQuiz'] == true;
    final n = _parseNullableInt(raw['totalQuestions'] ?? raw['quizCount'] ?? raw['totalQuizCount']);
    if (n != null && n > 0) return true;
    return true;
  }

  CourseLessonModel _parseLessonMap(Map<String, dynamic> lessonRaw, UserType userType, {String? fallbackLessonId}) {
    final idRaw = (lessonRaw['id'] ?? '').toString();
    final lessonId = idRaw.isNotEmpty ? idRaw : (fallbackLessonId ?? '');

    final durationSeconds = _parseInt(lessonRaw['duration']);
    final link = (lessonRaw['link'] ?? '').toString().trim();
    final videoUrl = link.isNotEmpty ? link : null;

    final totalQ = _parseNullableInt(
      lessonRaw['totalQuestions'] ??
          lessonRaw['quizTotalCount'] ??
          lessonRaw['quizCount'] ??
          lessonRaw['totalQuizCount'] ??
          lessonRaw['quiz_total_count'],
    );
    final correctA = _parseNullableInt(
      lessonRaw['correctAnswers'] ??
          lessonRaw['quizCorrectCount'] ??
          lessonRaw['correctQuizCount'] ??
          lessonRaw['quiz_correct_count'],
    );

    final isAttempted = userType == UserType.user && lessonRaw['isAttempted'] == true;
    final quizPassedFlag =
        userType == UserType.user && _parseBool(lessonRaw['quizPassed'] ?? lessonRaw['quiz_passed'] ?? lessonRaw['isQuizPassed']);

    return CourseLessonModel(
      id: lessonId,
      order: _parseInt(lessonRaw['orderIndex']),
      title: (lessonRaw['name'] ?? lessonRaw['title'] ?? '').toString(),
      duration: _formatDurationSeconds(durationSeconds),
      isLocked: lessonRaw['isLocked'] == true,
      isCompleted: userType == UserType.user && lessonRaw['isCompleted'] == true,
      videoUrl: videoUrl,
      quizPassed: quizPassedFlag,
      quizCorrectCount: correctA,
      quizTotalCount: totalQ,
      hasQuiz: _parseHasQuiz(lessonRaw),
      isQuizAttempted: isAttempted,
    );
  }

  double _parseDouble(dynamic value) => double.tryParse('${value ?? 0}') ?? 0;

  String _formatDurationSeconds(int seconds) {
    if (seconds <= 0) return '0:00';
    final totalMinutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$totalMinutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDurationCompact(int seconds) {
    if (seconds <= 0) return '0m';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours <= 0) return '${minutes}m';
    if (minutes == 0) return '${hours}s';
    return '${hours}s ${minutes}m';
  }

  int _parseDurationFromLabel(String label) {
    // label is `m:ss` from _formatDurationSeconds
    final parts = label.split(':');
    if (parts.length != 2) return 0;
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  }

  List<CourseReviewModel> _parseCourseReviews(dynamic raw) {
    if (raw == null) return const [];
    final list = raw is List ? raw.cast<dynamic>() : _asList(raw);
    if (list.isEmpty) return const [];
    final out = <CourseReviewModel>[];
    var i = 0;
    for (final item in list) {
      final m = _asMap(item);
      if (_parseBool(m['isHidden'] ?? m['is_hidden'])) continue;
      final user = _asMap(m['user'] ?? m['author'] ?? m['student']);
      final userName = [
        (m['userName'] ?? '').toString(),
        (m['authorName'] ?? '').toString(),
        (m['fullname'] ?? '').toString(),
        (user['fullname'] ?? '').toString(),
        (user['name'] ?? '').toString(),
        '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim(),
        '${user['firstname'] ?? ''} ${user['lastname'] ?? ''}'.trim(),
      ].map((s) => s.trim()).firstWhere((s) => s.isNotEmpty, orElse: () => '');
      final rating = _parseReviewStarRating(m['rating'] ?? m['stars'] ?? m['score']);
      final commentRaw = (m['comment'] ?? m['text'] ?? m['body'] ?? m['content'] ?? m['message'] ?? '').toString();
      final commentHtml = _commentToDisplayHtml(commentRaw);
      var id = (m['id'] ?? '').toString();
      if (id.isEmpty) {
        id = 'review_${i}_${userName.hashCode}';
      }
      i++;
      out.add(
        CourseReviewModel(
          id: id,
          userName: userName.isEmpty ? '—' : userName,
          userInitials: _initialsFromFullName(userName),
          createdAt: _parseDateTime(m['createdAt'] ?? m['created_at'] ?? m['date'] ?? m['updatedAt'] ?? m['updated_at']),
          rating: rating,
          commentHtml: commentHtml,
        ),
      );
    }
    return out;
  }

  int _parseReviewStarRating(dynamic value) {
    if (value is num) return value.round().clamp(0, 5);
    return int.tryParse('$value')?.clamp(0, 5) ?? 0;
  }

  String _commentToDisplayHtml(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return '';
    if (t.contains('<')) return t;
    final esc = t.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
    return '<p>$esc</p>';
  }

  List<CourseRatingBreakdownModel> _parseRatingBreakdown(dynamic raw, {required int totalReviewCount}) {
    if (raw == null) return const [];
    final byStar = <int, int>{};
    if (raw is Map) {
      final map = _asMap(raw);
      for (final e in map.entries) {
        final star = int.tryParse(e.key.toString());
        if (star == null || star < 1 || star > 5) continue;
        final v = e.value;
        final n = v is Map ? _parseInt(_asMap(v)['percent'] ?? _asMap(v)['percentage'] ?? _asMap(v)['count'] ?? _asMap(v)['value']) : _parseInt(v);
        if (n > 0) byStar[star] = n;
      }
    } else if (raw is List) {
      for (final item in _asList(raw)) {
        final m = _asMap(item);
        final star = _parseInt(m['stars'] ?? m['star'] ?? m['rating']).clamp(1, 5);
        var n = _parseInt(m['percent'] ?? m['percentage']);
        if (n == 0) n = _parseInt(m['count'] ?? m['value']);
        if (n > 0) byStar[star] = n;
      }
    }
    if (byStar.isEmpty) return const [];
    final values = byStar.values.toList();
    final sum = values.fold<int>(0, (a, b) => a + b);
    if (sum == 0) return const [];
    final useAsPercent = _shouldTreatRatingBreakdownAsPercents(sum: sum, values: values, totalReviewCount: totalReviewCount);
    return byStar.entries.map((e) => CourseRatingBreakdownModel(stars: e.key, percent: useAsPercent ? e.value.clamp(0, 100) : ((e.value * 100) / sum).round().clamp(0, 100))).toList(growable: false);
  }

  bool _shouldTreatRatingBreakdownAsPercents({required int sum, required List<int> values, required int totalReviewCount}) {
    if (!values.every((v) => v <= 100)) return false;
    if (sum >= 99 && sum <= 101) return true;
    if (totalReviewCount > 0 && sum == totalReviewCount) return false;
    return sum <= 100;
  }

  List<CourseRatingBreakdownModel> _mergeRatingBreakdownRows(List<CourseRatingBreakdownModel> parsed) {
    final byStar = {for (final r in parsed) r.stars: r.percent};
    return [5, 4, 3, 2, 1].map((s) => CourseRatingBreakdownModel(stars: s, percent: (byStar[s] ?? 0).clamp(0, 100))).toList(growable: false);
  }

  List<CourseRatingBreakdownModel> _ratingBreakdownFromReviews(List<CourseReviewModel> reviews) {
    final counts = <int, int>{for (var s = 1; s <= 5; s++) s: 0};
    for (final r in reviews) {
      if (r.rating < 1) continue;
      final s = r.rating.clamp(1, 5);
      counts[s] = (counts[s] ?? 0) + 1;
    }
    final total = reviews.where((r) => r.rating >= 1).length;
    return [5, 4, 3, 2, 1].map((s) => CourseRatingBreakdownModel(stars: s, percent: total > 0 ? (((counts[s] ?? 0) * 100) / total).round().clamp(0, 100) : 0)).toList(growable: false);
  }

  DateTime? _parseDateTime(dynamic v) {
    if (v == null) return null;
    if (v is int) {
      final ms = v < 200000000000 ? v * 1000 : v;
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    }
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s)?.toLocal();
  }

  String _initialsFromFullName(String name) {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final p = parts[0];
      return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
