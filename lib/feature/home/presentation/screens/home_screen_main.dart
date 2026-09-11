import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_state.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_pinned_app_bar.dart';

import 'package:qizlar_academy_mobile/feature/home/presentation/screens/home_screen_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onSwitchMainTab});

  /// Main tabs: Home, Courses, Leaderboard, Profile.
  final ValueChanged<int>? onSwitchMainTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with HomeScreenMixin<HomeScreen> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AuthSessionCubit, AuthSessionState>(
        bloc: getIt<AuthSessionCubit>(),
        builder: (context, auth) => BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final loading =
                state.status == HomeStatus.initial ||
                state.status == HomeStatus.loading;
            final topInset = HomePinnedAppBar.contentInset(context);
            return Scaffold(
              backgroundColor: context.isDarkTheme
                  ? context.appColors.background
                  : const Color(0xFFF7F7F5),
              body: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: buildAmbientBackground(),
                  ),
                  RefreshIndicator(
                    edgeOffset: topInset,
                    displacement: 48,
                    onRefresh: () async {
                      final bloc = context.read<HomeBloc>();
                      bloc.add(const HomeStarted());
                      await bloc.stream.firstWhere(
                        (s) =>
                            s.status == HomeStatus.success ||
                            s.status == HomeStatus.failure,
                      );
                    },
                    child: CustomScrollView(
                      controller: homeScrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: SizedBox(height: topInset)),
                        SliverToBoxAdapter(
                          child: buildLargeGreeting(
                            context,
                            userGreetingName: state.userGreetingName,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 36)),
                        if (auth.isAnonymous)
                          SliverToBoxAdapter(child: buildGuestCard(context)),
                        if (state.status == HomeStatus.failure)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 360,
                              child: AppFailureState(
                                message: context.l10n.homeLoadErrorMessage,
                                onRetry: () => context.read<HomeBloc>().add(
                                  const HomeStarted(),
                                ),
                              ),
                            ),
                          )
                        else ...[
                          if (!auth.isAnonymous)
                            SliverToBoxAdapter(
                              child: buildStatsSection(
                                context,
                                state.homeStats ??
                                    const HomeStatsModel(
                                      coins: 0,
                                      grade: 0,
                                      rating: 0,
                                      lastLessonCategory: '',
                                      lastLessonProgress: 0,
                                    ),
                                isLoading: loading,
                                onCoinsAndGradeTap: () => onTasksTap(context),
                                onRatingTap: () =>
                                    widget.onSwitchMainTab?.call(2),
                              ),
                            ),
                          const SliverToBoxAdapter(child: SizedBox(height: 28)),
                          SliverToBoxAdapter(
                            child: buildBannersSection(
                              context,
                              loading
                                  ? const [
                                      BannerModel(
                                        id: 'loading',
                                        title: '',
                                        subtitle: '',
                                        imageUrl: '',
                                      ),
                                    ]
                                  : state.banners,
                              isLoading: loading,
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 24)),
                          SliverToBoxAdapter(
                            child: buildCoursesSection(
                              context,
                              loading
                                  ? List<CourseModel>.generate(
                                      4,
                                      (i) => CourseModel(
                                        id: 'loading-$i',
                                        title: 'Course title placeholder',
                                        author: 'Mentor name',
                                        imageUrl: '',
                                        durationSeconds: 0,
                                        studentCount: 0,
                                      ),
                                    )
                                  : state.courses,
                              isLoading: loading,
                              onAllCoursesTap: () =>
                                  widget.onSwitchMainTab?.call(1),
                            ),
                          ),
                        ],
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.paddingOf(context).bottom + 112,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: buildPinnedAppBar(
                      context,
                      userGreetingName: state.userGreetingName,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
