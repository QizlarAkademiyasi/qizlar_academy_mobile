import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_full_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_top_performers_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/screens/leaderboard_screen_mixin.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [LeaderboardBloc] [app_routes] dagi [MainScreen] ota-providers orqali beriladi.
    return const _LeaderboardView();
  }
}

class _LeaderboardView extends StatefulWidget {
  const _LeaderboardView();

  @override
  State<_LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<_LeaderboardView>
    with
        LeaderboardScreenMixin<_LeaderboardView>,
        SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _timeframePageController;
  bool _syncingFromBloc = false;
  bool _syncingFromPage = false;
  static const double _pinnedFiltersHeight = 140;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _timeframePageController = PageController(
      initialPage: _tabController.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timeframePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<LeaderboardBloc, LeaderboardState>(
        listener: (context, state) {
          leaderboardBlocListener(context, state);
          if (_tabController.index != state.timeframe.index) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_tabController.index != state.timeframe.index) {
                _tabController.animateTo(state.timeframe.index);
              }
            });
          }

          if (_timeframePageController.hasClients &&
              _timeframePageController.page?.round() != state.timeframe.index) {
            _syncingFromBloc = true;
            _timeframePageController.jumpToPage(state.timeframe.index);
            _syncingFromBloc = false;
          }
        },
        builder: (context, state) {
          if (state.status == LeaderboardStatus.failure &&
              state.courseOptions.isEmpty) {
            return AppFailureState(
              message: context.l10n.leaderboardLoadError,
              onRetry: () {
                context.read<LeaderboardBloc>().add(const LeaderboardStarted());
              },
            );
          }

          final isLoading = state.status == LeaderboardStatus.loading;
          final awaitingFirstPayload =
              state.courseOptions.isEmpty &&
              state.fullList.isEmpty &&
              state.topThree.isEmpty;
          // initial: PageView + KeepAlive — birinchi buildda event hali
          // qayta ishlanmaguncha status `initial` bo‘lib qoladi; skeleton shu
          // paytda ham ko‘rinishi kerak.
          final isBootstrapping =
              awaitingFirstPayload &&
              (state.status == LeaderboardStatus.initial ||
                  state.status == LeaderboardStatus.loading);

          final matched = state.courseOptions
              .where((c) => c.id == state.selectedCourseId)
              .toList();
          final selectedCourse = matched.isEmpty ? null : matched.first;
          final l10n = context.l10n;
          final selectedCourseName = isBootstrapping
              ? l10n.leaderboardSelectCourse
              : (selectedCourse?.name ??
                    (state.courseOptions.isNotEmpty
                        ? state.courseOptions.first.name
                        : l10n.leaderboardSelectCourse));

          final displayTopThree = state.topThree.isNotEmpty
              ? state.topThree
              : state.fullList.take(3).toList();

          final bottomInset = MediaQuery.paddingOf(context).bottom;

          if (!isLoading && state.status == LeaderboardStatus.success) {
            if (state.courseOptions.isEmpty) {
              return Center(
                child: Padding(
                  padding: AppPadding.paddingXl,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TgsEmptyContent(
                        message: context.l10n.leaderboardNoCourses,
                        animationSize: 92,
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton.elevated(
                        label: context.l10n.refresh,
                        onPressed: () {
                          context.read<LeaderboardBloc>().add(
                            const LeaderboardStarted(),
                          );
                        },
                        expand: false,
                      ),
                    ],
                  ),
                ),
              );
            }
          }

          return SafeArea(
            bottom: false,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverPadding(
                  padding: AppPadding.paddingHorizontalLg,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLeaderboardHeader(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedFiltersDelegate(
                    height: _pinnedFiltersHeight,
                    child: Padding(
                      padding: AppPadding.paddingHorizontalLg,
                      child: Column(
                        children: [
                          buildLeaderboardTabs(
                            context,
                            tabController: _tabController,
                            onChanged: (index) {
                              if (_syncingFromPage) return;
                              onTimeframeChanged(index);
                              _syncingFromBloc = true;
                              _timeframePageController.jumpToPage(index.index);
                              _syncingFromBloc = false;
                            },
                          ),
                          const SizedBox(height: 16),
                          buildLeaderboardCategoryDropdown(
                            context,
                            selectedCourseName: selectedCourseName,
                            onTap: isBootstrapping || isLoading
                                ? () {}
                                : () => onCategoryTap(
                                    context,
                                    options: state.courseOptions,
                                    selectedId: state.selectedCourseId,
                                  ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _timeframePageController,
                itemCount: 3,
                onPageChanged: (index) {
                  if (_syncingFromBloc) return;
                  _syncingFromPage = true;
                  onTimeframeChanged(LeaderboardTimeframe.values[index]);
                  if (_tabController.index != index) {
                    _tabController.animateTo(index);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _syncingFromPage = false;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  // UX: hozirgi timeframe'dan boshqa sahifalarda ham bir xil layout ko'rinadi;
                  // timeframe o'zgarganda bloc state yangilanadi va PageView animatsiya bilan
                  // yangi data ko'rsatadi.
                  if (isBootstrapping) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      children: const [
                        LeaderboardTopPerformersSkeleton(),
                        SizedBox(height: 24),
                        LeaderboardFullListSkeleton(),
                      ],
                    );
                  }

                  if (!isLoading && state.fullList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: AppPadding.paddingHorizontalLg,
                        child: TgsEmptyContent(
                          message: context.l10n.leaderboardNoRatingYet,
                          animationSize: 150,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      24 + bottomInset + 48,
                    ),
                    children: [
                      buildLeaderboardTopPerformers(
                        context,
                        topThree: displayTopThree,
                        onUserTap: (user) {
                          if (isLoading) return;
                          onLeaderboardUserTap(context, user);
                        },
                      ),
                      const SizedBox(height: 24),
                      buildLeaderboardFullList(
                        context,
                        fullList: state.fullList,
                        onUserTap: (user) {
                          if (isLoading) return;
                          onLeaderboardUserTap(context, user);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PinnedFiltersDelegate extends SliverPersistentHeaderDelegate {
  _PinnedFiltersDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: height,
      child: AppBlurredHeaderSurface(child: child),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedFiltersDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}
