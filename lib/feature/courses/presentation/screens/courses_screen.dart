import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CoursesCatalogBloc>()..add(const CoursesCatalogStarted()),
      child: const _CoursesView(),
    );
  }
}

class _CoursesView extends StatefulWidget {
  const _CoursesView();

  @override
  State<_CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<_CoursesView>
    with CoursesScreenMixin<_CoursesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<CoursesCatalogBloc, CoursesCatalogState>(
          listener: coursesBlocListener,
          builder: (context, state) {
            final isInitialLoading =
                (state.status == CoursesCatalogStatus.loading ||
                    state.status == CoursesCatalogStatus.initial) &&
                !state.hasData;

            return Column(
              children: [
                buildTopBar(context),
                buildSearchField(context),
                const SizedBox(height: 14),
                Expanded(
                  child: switch ((
                    state.status,
                    state.hasData,
                    isInitialLoading,
                  )) {
                    (CoursesCatalogStatus.failure, false, _) =>
                      TgsFailureContent(
                        message: state.message,
                        onRetry: () => retry(context),
                      ),
                    (_, _, true) => const CoursesListSkeleton(),
                    _ => _buildContent(context, state),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CoursesCatalogState state) {
    final overview = state.overview;
    if (overview == null || overview.isEmpty) {
      return Center(
        child: Text(
          'Mos kurs topilmadi',
          style: context.textTheme.bodyLargeRegular.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
      );
    }

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 92 + bottomInset),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (overview.lastViewedCourse != null) ...[
                buildInProgressCard(context, overview.lastViewedCourse!),
                const SizedBox(height: 16),
              ],
              ...overview.courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: buildCourseCard(context, course),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
