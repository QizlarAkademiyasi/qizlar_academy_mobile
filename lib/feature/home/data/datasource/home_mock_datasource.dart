import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';

class HomeMockDatasource {
  static const _delay = Duration(milliseconds: 300);

  Future<HomeStatsModel> getStats() async {
    await Future<void>.delayed(_delay);
    return const HomeStatsModel(
      coins: 17,
      grade: 17,
      rating: 985,
      lastLessonCategory: 'Marketolog',
      lastLessonProgress: 0.15,
    );
  }

  Future<List<CategoryModel>> getCategories() async {
    await Future<void>.delayed(_delay);
    return const [
      CategoryModel(id: '1', name: 'Yangilik', imageUrl: 'https://picsum.photos/seed/cat1/80/80'),
      CategoryModel(id: '2', name: 'Vizajistlik', imageUrl: 'https://picsum.photos/seed/cat2/80/80'),
      CategoryModel(id: '3', name: 'IT kurslari', imageUrl: 'https://picsum.photos/seed/cat3/80/80'),
      CategoryModel(id: '4', name: "San'at", imageUrl: 'https://picsum.photos/seed/cat4/80/80'),
      CategoryModel(id: '5', name: 'Foto', imageUrl: 'https://picsum.photos/seed/cat5/80/80'),
    ];
  }

  Future<List<TeacherModel>> getTeachers() async {
    await Future<void>.delayed(_delay);
    return const [
      TeacherModel(
        id: '1',
        name: 'Munisa Xakberdiyeva',
        specialty: 'Marketolog',
        imageUrl: 'https://picsum.photos/seed/t1/200/200',
        coursesCount: 12,
      ),
      TeacherModel(
        id: '2',
        name: 'Nilufar Rashidova',
        specialty: 'Vizajist',
        imageUrl: 'https://picsum.photos/seed/t2/200/200',
        coursesCount: 8,
      ),
      TeacherModel(
        id: '3',
        name: 'Zulfiya Tosheva',
        specialty: 'IT mutaxassisi',
        imageUrl: 'https://picsum.photos/seed/t3/200/200',
        coursesCount: 15,
      ),
    ];
  }

  Future<List<CourseModel>> getCourses() async {
    await Future<void>.delayed(_delay);
    return const [
      CourseModel(
        id: '1',
        title: 'Creative Writing Masterclass',
        author: 'Sarah J. Maas',
        imageUrl: 'https://picsum.photos/seed/c1/120/120',
        durationHours: 5,
        studentCount: 1200,
      ),
      CourseModel(
        id: '2',
        title: 'Digital Marketing Asoslari',
        author: 'Munisa Xakberdiyeva',
        imageUrl: 'https://picsum.photos/seed/c2/120/120',
        durationHours: 8,
        studentCount: 850,
      ),
      CourseModel(
        id: '3',
        title: 'Vizaj san\'ati: Professional kurs',
        author: 'Nilufar Rashidova',
        imageUrl: 'https://picsum.photos/seed/c3/120/120',
        durationHours: 12,
        studentCount: 640,
      ),
    ];
  }
}
