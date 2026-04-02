import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_course_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_courses_pagination_model.dart';

class MyCoursesPageModel extends Equatable {
  const MyCoursesPageModel({required this.items, required this.pagination});

  final List<MyCourseItemModel> items;
  final MyCoursesPaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
