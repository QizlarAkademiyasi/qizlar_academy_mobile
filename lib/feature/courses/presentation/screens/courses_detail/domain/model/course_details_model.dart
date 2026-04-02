import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_module_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_review_model.dart';

class CourseDetailsModel extends Equatable {
  const CourseDetailsModel({
    required this.id,
    required this.title,
    required this.categoryName,
    required this.isEnrolled,
    required this.teacherName,
    required this.teacherRole,
    required this.coverImageUrl,
    required this.teacherAvatarUrl,
    required this.rating,
    required this.reviewsCount,
    required this.studentsCount,
    required this.totalDurationText,
    required this.lessonsCount,
    required this.progressRatio,
    required this.progressLessonsText,
    required this.progressSeenText,
    required this.progressDurationText,
    required this.description,
    required this.teacherDescription,
    required this.ratingBreakdown,
    required this.reviews,
    required this.modules,
  });

  final String id;
  final String title;

  /// Masalan kategoriya nomi (badge uchun).
  final String categoryName;

  /// Ro‘yxatdan o‘tgan foydalanuvchi kursga yozilganmi (API `isEnrolled` yoki shunga o‘xshash).
  final bool isEnrolled;
  final String teacherName;
  final String teacherRole;

  final String coverImageUrl;
  final String teacherAvatarUrl;

  final double rating;
  final int reviewsCount;
  final int studentsCount;
  final String totalDurationText;
  final int lessonsCount;

  /// 0..1
  final double progressRatio;

  /// UI uchun: "2/20 dars"
  final String progressLessonsText;

  /// UI uchun: "2 ta dars ko‘rilgan"
  final String progressSeenText;

  /// UI uchun: "3s 22m umumiy"
  final String progressDurationText;

  final String description;
  final String teacherDescription;
  final List<CourseRatingBreakdownModel> ratingBreakdown;
  final List<CourseReviewModel> reviews;
  final List<CourseModuleModel> modules;

  @override
  List<Object?> get props => [
    id,
    title,
    categoryName,
    isEnrolled,
    teacherName,
    teacherRole,
    coverImageUrl,
    teacherAvatarUrl,
    rating,
    reviewsCount,
    studentsCount,
    totalDurationText,
    lessonsCount,
    progressRatio,
    progressLessonsText,
    progressSeenText,
    progressDurationText,
    description,
    teacherDescription,
    ratingBreakdown,
    reviews,
    modules,
  ];
}

extension CourseDetailsModelGuestPreviewX on CourseDetailsModel {
  /// Modullar va tartib bo‘yicha birinchi dars id (mehmon uchun preview).
  String? get firstGuestPreviewLessonId {
    for (final m in modules) {
      for (final l in m.lessons) {
        if (l.id.isNotEmpty) return l.id;
      }
    }
    return null;
  }
}
