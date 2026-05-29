import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_in_progress_model.dart';

class CoursesCatalogOverviewModel extends Equatable {
  const CoursesCatalogOverviewModel({
    this.lastViewedCourse,
    this.courses = const [],
  });

  final CourseInProgressModel? lastViewedCourse;
  final List<CourseCatalogItemModel> courses;

  bool get isEmpty => lastViewedCourse == null && courses.isEmpty;

  @override
  List<Object?> get props => [lastViewedCourse, courses];
}
