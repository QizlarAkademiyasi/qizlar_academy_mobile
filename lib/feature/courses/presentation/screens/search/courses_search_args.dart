import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';

/// [Routes.coursesSearch] — `GoRouter.extra`.
class CoursesSearchArgs {
  const CoursesSearchArgs({required this.catalogBloc, required this.initialQuery});

  final CoursesCatalogBloc catalogBloc;
  final String initialQuery;
}
