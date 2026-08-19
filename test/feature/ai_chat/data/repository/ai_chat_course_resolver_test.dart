import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/repository/ai_chat_course_resolver_impl.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';

void main() {
  test(
    'resolves ids in request order from memory, home, then catalog',
    () async {
      final home = _FakeHomeRepository()
        ..courses = const [
          CourseModel(
            id: 'home-1',
            title: 'Home course',
            author: 'Madina',
            imageUrl: '',
            durationSeconds: 120 * 60,
            studentCount: 10,
          ),
        ];
      final catalog = _FakeCatalogRepository()
        ..courses = const [
          CourseCatalogItemModel(
            id: 'catalog-1',
            title: 'Catalog course',
            mentorName: 'Laylo',
            imageUrl: '',
            rating: 4.8,
            reviewsCount: 20,
            durationSeconds: 90 * 60,
          ),
        ];
      final details = _FakeCoursesRepository();
      final resolver = AiChatCourseResolverImpl(
        homeRepository: home,
        catalogRepository: catalog,
        coursesRepository: details,
      );
      resolver.remember(const [
        AiChatCourseModel(
          id: 'mem-1',
          title: 'Memory course',
          mentorName: 'Zarina',
          imageUrl: '',
        ),
      ]);

      final result = await resolver.resolve(['catalog-1', 'mem-1', 'home-1']);

      expect(result.map((course) => course.id), [
        'catalog-1',
        'mem-1',
        'home-1',
      ]);
      expect(details.fetchCount, 0);
    },
  );

  test('skips unresolved ids and does not call details on cache hit', () async {
    final home = _FakeHomeRepository()
      ..courses = const [
        CourseModel(
          id: 'course-1',
          title: 'Grafik dizayn',
          author: 'Madina',
          imageUrl: 'https://img',
          durationSeconds: 360 * 60,
          studentCount: 1,
        ),
      ];
    final details = _FakeCoursesRepository()..fail = true;
    final resolver = AiChatCourseResolverImpl(
      homeRepository: home,
      catalogRepository: _FakeCatalogRepository(),
      coursesRepository: details,
    );

    final first = await resolver.resolve(['ghost', 'course-1']);
    final second = await resolver.resolve(['course-1']);

    expect(first.single.title, 'Grafik dizayn');
    expect(first.single.durationMinutes, 360);
    expect(second.single.id, 'course-1');
    expect(home.getCoursesCount, 1);
    expect(details.fetchCount, 1);
  });
}

class _FakeHomeRepository implements HomeRepository {
  List<CourseModel> courses = const [];
  var getCoursesCount = 0;

  @override
  Future<List<CourseModel>> getCourses() async {
    getCoursesCount += 1;
    return courses;
  }

  @override
  Future<List<BannerModel>> getBanners() async => const [];

  @override
  Future<List<StoryModel>> getCategories() async => const [];

  @override
  Future<HomeStatsModel> getStats() async => const HomeStatsModel(
    coins: 0,
    grade: 0,
    rating: 0,
    lastLessonCategory: '',
    lastLessonProgress: 0,
  );

  @override
  Future<List<TeacherModel>> getTeachers() async => const [];

  @override
  Future<void> postStoryView(String storyId) async {}
}

class _FakeCatalogRepository implements CoursesCatalogRepository {
  List<CourseCatalogItemModel> courses = const [];

  @override
  Future<CoursesCatalogOverviewModel> fetchCatalog({
    required String query,
  }) async {
    return CoursesCatalogOverviewModel(courses: courses);
  }
}

class _FakeCoursesRepository implements CoursesRepository {
  var fetchCount = 0;
  var fail = false;

  @override
  Future<CourseDetailsModel> fetchCourseDetails({
    required String courseId,
  }) async {
    fetchCount += 1;
    if (fail) throw Exception('offline');
    return CourseDetailsModel(
      id: courseId,
      title: 'Details $courseId',
      categoryName: '',
      isEnrolled: false,
      teacherName: 'Mentor',
      teacherRole: '',
      coverImageUrl: '',
      teacherAvatarUrl: '',
      rating: 4.2,
      reviewsCount: 8,
      studentsCount: 0,
      totalDurationText: '2h',
      lessonsCount: 12,
      progressRatio: 0,
      progressLessonsText: '',
      progressSeenText: '',
      progressDurationText: '',
      description: '',
      teacherDescription: '',
      ratingBreakdown: const [],
      reviews: const [],
      modules: const [],
    );
  }

  @override
  Future<CourseLessonModel> fetchLessonDetails({
    required String lessonId,
    String? courseId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> completeLesson({required String lessonId}) async {}

  @override
  Future<void> enrollInCourse({required String courseId}) async {}

  @override
  Future<void> submitCourseRating({
    required String courseId,
    required double rating,
    required String comment,
  }) async {}
}
