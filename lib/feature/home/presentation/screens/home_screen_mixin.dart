import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_category_item.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_stats_section.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_teacher_card.dart';

mixin HomeScreenMixin<T extends StatefulWidget> on State<T> {
  Widget buildHeader(BuildContext context, String userName) {
    return HomeHeaderComponent(userName: userName);
  }

  Widget buildCategoriesRow(BuildContext context, List<CategoryModel> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Kategoriyalar',
            style: context.textTheme.heading6.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) => HomeCategoryItem(category: categories[index]),
          ),
        ),
      ],
    );
  }

  Widget buildStatsSection(BuildContext context, HomeStatsModel stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Statistika',
            style: context.textTheme.heading6.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),
        HomeStatsSection(stats: stats),
      ],
    );
  }

  Widget buildTeachersRow(BuildContext context, List<TeacherModel> teachers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "O'qituvchilar",
            style: context.textTheme.heading6.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: teachers.length,
            itemBuilder: (context, index) => HomeTeacherCard(teacher: teachers[index]),
          ),
        ),
      ],
    );
  }

  Widget buildCoursesSection(BuildContext context, List<CourseModel> courses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mashhur kurslar',
            style: context.textTheme.heading6.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...courses.map((course) => HomeCourseCard(course: course)),
        ],
      ),
    );
  }

  void homeBlocListener(BuildContext context, HomeState state) {
    if (state.status == HomeStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message ?? 'Xatolik yuz berdi'),
          backgroundColor: AppColors.redAction,
        ),
      );
    }
  }
}
