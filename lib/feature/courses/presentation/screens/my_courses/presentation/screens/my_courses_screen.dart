import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/components/my_courses_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/screens/my_courses_screen_mixin.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<MyCoursesBloc>()..add(const MyCoursesStarted()), child: const _MyCoursesView());
  }
}

class _MyCoursesView extends StatefulWidget {
  const _MyCoursesView();

  @override
  State<_MyCoursesView> createState() => _MyCoursesViewState();
}

class _MyCoursesViewState extends State<_MyCoursesView> with MyCoursesScreenMixin<_MyCoursesView> {
  bool _onScrollNotification(ScrollNotification n, BuildContext context) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) {
      return false;
    }
    final m = n.metrics;
    if (m.pixels >= m.maxScrollExtent - 220) {
      onScrollNearEnd(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<MyCoursesBloc, MyCoursesState>(
          listenWhen: (previous, current) => current.loadMoreFailed && !previous.loadMoreFailed,
          listener: myCoursesBlocListener,
          builder: (context, state) {
            final isInitialLoading = (state.status == MyCoursesStatus.loading || state.status == MyCoursesStatus.initial) && state.courses.isEmpty;

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: buildMyCoursesTopBar(context)),
                    Expanded(
                      child: switch (state.status) {
                        MyCoursesStatus.failure when state.courses.isEmpty => TgsFailureContent(message: context.l10n.myCoursesLoadError, onRetry: () => retryFirstPage(context)),
                        _ when isInitialLoading => const Padding(padding: EdgeInsets.only(top: 4), child: MyCoursesListSkeleton()),
                        MyCoursesStatus.success when state.courses.isEmpty => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: TgsEmptyContent(message: context.l10n.myCoursesEmptyTitle, subtitle: context.l10n.myCoursesEmptySubtitle),
                          ),
                        ),
                        _ => NotificationListener<ScrollNotification>(
                          onNotification: (n) => _onScrollNotification(n, context),
                          child: AppStaggeredScrollLimiter(
                            child: CustomScrollView(
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate((context, index) {
                                      if (index >= state.courses.length) {
                                        return Skeletonizer.zone(
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            child: Center(child: Bone.text(words: 4)),
                                          ),
                                        );
                                      }
                                      return AppStaggeredListItem(
                                        position: index,
                                        child: buildMyCourseListTile(context, state: state, index: index),
                                      );
                                    }, childCount: state.courses.length + (state.isLoadingMore ? 1 : 0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: context.isDarkTheme ? UiKitAssets.images.bottomNavDark.image(fit: BoxFit.cover) : UiKitAssets.images.bottomNavLight.image(fit: BoxFit.cover),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
