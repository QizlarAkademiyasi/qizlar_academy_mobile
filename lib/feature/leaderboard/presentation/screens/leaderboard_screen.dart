import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/failure_content.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/screens/leaderboard_screen_mixin.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LeaderboardBloc>()..add(const LeaderboardStarted()),
      child: const _LeaderboardView(),
    );
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
  static const List<LeaderboardCourseOptionModel> _skeletonCourses = [
    LeaderboardCourseOptionModel(id: 'skeleton-course', name: 'Vizajistlik kursi'),
  ];

  static const List<LeaderboardUserModel> _skeletonUsers = [
    LeaderboardUserModel(
      id: 's-1',
      userCode: '000001',
      fullName: 'Lola Rahimova',
      avatarUrl: 'https://example.com/avatar-1.png',
      rank: 1,
      score: 9850,
      courseName: 'Vizajistlik kursi',
      finishedCoursesCount: 12,
      certificatesCount: 12,
      followerCount: '1.9k',
      rating: 5.0,
    ),
    LeaderboardUserModel(
      id: 's-2',
      userCode: '000002',
      fullName: 'Nodira Karimova',
      avatarUrl: 'https://example.com/avatar-2.png',
      rank: 2,
      score: 8790,
      courseName: 'Vizajistlik kursi',
      finishedCoursesCount: 10,
      certificatesCount: 10,
      followerCount: '1.2k',
      rating: 5.0,
    ),
    LeaderboardUserModel(
      id: 's-3',
      userCode: '000003',
      fullName: 'Malika Nazarova',
      avatarUrl: 'https://example.com/avatar-3.png',
      rank: 3,
      score: 8420,
      courseName: 'Vizajistlik kursi',
      finishedCoursesCount: 9,
      certificatesCount: 9,
      followerCount: '980',
      rating: 5.0,
    ),
    LeaderboardUserModel(
      id: 's-4',
      userCode: '000004',
      fullName: 'Dilnoza Rahimova',
      avatarUrl: 'https://example.com/avatar-4.png',
      rank: 4,
      score: 8100,
      courseName: 'Vizajistlik kursi',
      finishedCoursesCount: 8,
      certificatesCount: 8,
      followerCount: '740',
      rating: 5.0,
    ),
    LeaderboardUserModel(
      id: 's-5',
      userCode: '000005',
      fullName: 'Sevinch Karimova',
      avatarUrl: 'https://example.com/avatar-5.png',
      rank: 5,
      score: 7820,
      courseName: 'Vizajistlik kursi',
      finishedCoursesCount: 7,
      certificatesCount: 7,
      followerCount: '630',
      rating: 5.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        },
        builder: (context, state) {
          if (state.status == LeaderboardStatus.failure &&
              state.courseOptions.isEmpty) {
            return FailureContent(
              message: state.message,
              onRetry: () {
                context.read<LeaderboardBloc>().add(const LeaderboardStarted());
              },
            );
          }

          final isSkeleton = state.status == LeaderboardStatus.loading;
          final displayCourseOptions = state.courseOptions.isNotEmpty
              ? state.courseOptions
              : _skeletonCourses;
          final displayFullList = state.fullList.isNotEmpty
              ? state.fullList
              : _skeletonUsers;
          final displayTopThree = state.topThree.isNotEmpty
              ? state.topThree
              : displayFullList.take(3).toList();

          final matched = displayCourseOptions
              .where((c) => c.id == state.selectedCourseId)
              .toList();
          final selectedCourse = matched.isEmpty ? null : matched.first;
          final selectedCourseName =
              selectedCourse?.name ?? 'Vizajistlik kursi';

          final bottomInset = MediaQuery.paddingOf(context).bottom;

          final content = SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Yuqori sarlavha — scroll bilan ketadi
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
                // Tabs + dropdown — pin: scroll qilganda yuqorida qotib qoladi
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedFilterDelegate(
                    backgroundColor: context.theme.scaffoldBackgroundColor,
                    paddingHorizontal: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildLeaderboardTabs(
                          context,
                          tabController: _tabController,
                          onChanged: onTimeframeChanged,
                        ),
                        const SizedBox(height: 16),
                        buildLeaderboardCategoryDropdown(
                          context,
                          selectedCourseName: selectedCourseName,
                          onTap: isSkeleton
                              ? () {}
                              : () => onCategoryTap(
                                    context,
                                    options: displayCourseOptions,
                                    selectedId: state.selectedCourseId,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Qolgan kontent — podium, reyting, banner
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + bottomInset),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      buildLeaderboardTopPerformers(
                        context,
                        topThree: displayTopThree,
                        onUserTap: (user) {
                          if (isSkeleton) return;
                          onLeaderboardUserTap(context, user);
                        },
                      ),
                      const SizedBox(height: 24),
                      buildLeaderboardFullList(
                        context,
                        fullList: displayFullList,
                        onUserTap: (user) {
                          if (isSkeleton) return;
                          onLeaderboardUserTap(context, user);
                        },
                      ),
                      const SizedBox(height: 20),
                      buildLeaderboardPromotionBanner(
                        context,
                        onStartTap: isSkeleton ? () {} : onStartTap,
                      ),
                    ]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
                ),
              ],
            ),
          );

          if (!isSkeleton) return content;

          return Skeletonizer.zone(
            child: IgnorePointer(
              child: content,
            ),
          );
        },
      ),
    );
  }
}

/// Tabs va category dropdown uchun pin qilingan boshqaruv — scroll da yuqorida qotib turadi.
class _PinnedFilterDelegate extends SliverPersistentHeaderDelegate {
  _PinnedFilterDelegate({
    required this.backgroundColor,
    required this.paddingHorizontal,
    required this.child,
  });

  final Color backgroundColor;
  final double paddingHorizontal;
  final Widget child;

  /// layoutExtent == paintExtent bo'lishi kerak; child haqiqiy o'lchami (~122) bilan mos.
  static const double _height = 122; // 56 (tabs) + 16 + 50 (dropdown)

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _height,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedFilterDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.paddingHorizontal != paddingHorizontal ||
        oldDelegate.child != child;
  }
}
