import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_module_model.dart';

/// Modul ketma-ketligi va kursni to‘liq tugatish holatini hisoblash (mijoz tomonida).
abstract final class CourseCurriculumProgress {
  CourseCurriculumProgress._();

  /// Dars videosi ko‘rilgan va (mavjud bo‘lsa) test **muvaffaqiyatli** topshirilgan (`quizPassed`).
  static bool isLessonFullyComplete(CourseLessonModel lesson) {
    if (!lesson.isCompleted) return false;
    if (lesson.hasQuiz) return lesson.quizPassed;
    return true;
  }

  static bool isModuleFullyComplete(CourseModuleModel module) {
    if (module.lessons.isEmpty) return true;
    return module.lessons.every(isLessonFullyComplete);
  }

  static bool isCourseFullyComplete(List<CourseModuleModel> modules) {
    if (modules.isEmpty) return false;
    return modules.every(isModuleFullyComplete);
  }

  /// `GET .../course/{id}/module` dagi [CourseLessonModel.isLocked] — backend qulf holati.
  static bool canAccessLesson(List<CourseModuleModel> modules, String lessonId) {
    final flat = modules.expand((m) => m.lessons).toList();
    final idx = flat.indexWhere((l) => l.id == lessonId);
    if (idx < 0) return false;
    return !flat[idx].isLocked;
  }

  /// Oxirgi modul, [order] bo‘yicha tartiblangan oxirgi dars id (API tartibiga tayanadi).
  static String? terminalLessonId(List<CourseModuleModel> modules) {
    if (modules.isEmpty) return null;
    final last = modules.last;
    if (last.lessons.isEmpty) return null;
    final sorted = List<CourseLessonModel>.from(last.lessons)..sort((a, b) => a.order.compareTo(b.order));
    final id = sorted.last.id.trim();
    return id.isEmpty ? null : id;
  }

  static bool isTerminalLessonWithQuiz(List<CourseModuleModel> modules, String lessonId) {
    final tid = terminalLessonId(modules);
    if (tid == null || tid != lessonId) return false;
    CourseLessonModel? lesson;
    for (final m in modules) {
      for (final l in m.lessons) {
        if (l.id == lessonId) lesson = l;
      }
    }
    return lesson?.hasQuiz ?? false;
  }

  /// Kurs tugadi va oxirgi darsda test bor — tabriklash dialogi sertifikat sheet bilan dublikat bo‘lmasligi uchun.
  static bool courseFinishedWithTerminalLessonQuiz(List<CourseModuleModel> modules) {
    if (!isCourseFullyComplete(modules)) return false;
    final tid = terminalLessonId(modules);
    if (tid == null) return false;
    CourseLessonModel? lesson;
    for (final m in modules) {
      for (final l in m.lessons) {
        if (l.id == tid) lesson = l;
      }
    }
    if (lesson == null || !lesson.hasQuiz) return false;
    return isLessonFullyComplete(lesson);
  }
}
