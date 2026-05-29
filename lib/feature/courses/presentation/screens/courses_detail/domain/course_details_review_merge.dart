import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_review_model.dart';

/// Sharhlar ro‘yxatidan [rating], [reviewsCount], [ratingBreakdown] ni qayta hisoblaydi.
CourseDetailsModel applyReviewsToCourseDetails(
  CourseDetailsModel base,
  List<CourseReviewModel> reviews,
) {
  final sorted = List<CourseReviewModel>.from(reviews)
    ..sort((a, b) {
      final ta = a.createdAt;
      final tb = b.createdAt;
      if (ta == null && tb == null) return 0;
      if (ta == null) return 1;
      if (tb == null) return -1;
      return tb.compareTo(ta);
    });

  final rated = sorted.where((r) => r.rating >= 1).toList();
  final avg = rated.isEmpty
      ? base.rating
      : rated.fold<double>(0, (s, r) => s + r.rating) / rated.length;

  final breakdown = _ratingBreakdownFromReviews(sorted);

  return CourseDetailsModel(
    id: base.id,
    title: base.title,
    categoryName: base.categoryName,
    isEnrolled: base.isEnrolled,
    teacherName: base.teacherName,
    teacherRole: base.teacherRole,
    coverImageUrl: base.coverImageUrl,
    teacherAvatarUrl: base.teacherAvatarUrl,
    rating: avg,
    reviewsCount: sorted.length,
    studentsCount: base.studentsCount,
    totalDurationText: base.totalDurationText,
    lessonsCount: base.lessonsCount,
    progressRatio: base.progressRatio,
    progressLessonsText: base.progressLessonsText,
    progressSeenText: base.progressSeenText,
    progressDurationText: base.progressDurationText,
    description: base.description,
    teacherDescription: base.teacherDescription,
    ratingBreakdown: breakdown,
    reviews: sorted,
    modules: base.modules,
  );
}

List<CourseRatingBreakdownModel> _ratingBreakdownFromReviews(List<CourseReviewModel> reviews) {
  final counts = <int, int>{for (var s = 1; s <= 5; s++) s: 0};
  for (final r in reviews) {
    if (r.rating < 1) continue;
    final s = r.rating.clamp(1, 5);
    counts[s] = (counts[s] ?? 0) + 1;
  }
  final total = reviews.where((r) => r.rating >= 1).length;
  return [5, 4, 3, 2, 1]
      .map(
        (s) => CourseRatingBreakdownModel(
          stars: s,
          percent: total > 0 ? (((counts[s] ?? 0) * 100) / total).round().clamp(0, 100) : 0,
        ),
      )
      .toList(growable: false);
}
