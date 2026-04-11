import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_state.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/story_bar_widget.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/home_screen_mixin.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onSwitchMainTab});

  /// Asosiy shell ichidagi tab indeksi (0 — bosh sahifa, 1 — kurslar, 2 — liderbord, 3 — profil).
  final ValueChanged<int>? onSwitchMainTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeScreenMixin<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _headerOverscrollSnapScheduled = false;

  /// [MainScreen] PageView / pastki bar tartibi bilan mos.
  static const int _mainTabLeaderboard = 2;
  static const int _mainTabProfile = 3;

  static const HomeStatsModel _skeletonStats = HomeStatsModel(coins: 1200, grade: 12, rating: 8, lastLessonCategory: 'Arab tili', lastLessonProgress: 0.6);
  static const List<CourseModel> _skeletonCourses = [
    CourseModel(id: 'c1', title: 'Arab tiliga kirish', author: 'Mentor', imageUrl: '', durationHours: 24, studentCount: 1000),
    CourseModel(id: 'c2', title: 'Ayollar psixologiyasi', author: 'Mentor', imageUrl: '', durationHours: 16, studentCount: 740),
  ];
  static const List<BannerModel> _skeletonBanners = [
    BannerModel(id: 'b1', title: '', subtitle: '', imageUrl: ''),
    BannerModel(id: 'b2', title: '', subtitle: '', imageUrl: ''),
    BannerModel(id: 'b3', title: '', subtitle: '', imageUrl: ''),
  ];

  Widget _staggeredSection({required int position, required Widget child}) {
    return AppStaggeredListItem(position: position, child: child);
  }

  static const double _headerSnapThresholdLow = 0.8 * kToolbarHeight;
  static const double _headerSnapThresholdHigh = 1.8 * kToolbarHeight;

  /// [UserScrollNotification] + sinxron [animateTo] ba’zan pointerDown bilan
  /// ziddiyatda `Scrollable` `_hold` assertini keltirib chiqaradi. Snapni keyingi
  /// frame’da va faqat scroll tinchganda ishga tushiramiz.
  void _scheduleHeaderOverscrollSnap() {
    if (_headerOverscrollSnapScheduled) return;
    _headerOverscrollSnapScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerOverscrollSnapScheduled = false;
      if (!mounted || !_scrollController.hasClients) return;
      final position = _scrollController.position;
      if (position.isScrollingNotifier.value) return;

      final offset = _scrollController.offset;
      if (!offset.isFinite || offset > _headerSnapThresholdHigh) return;

      final isToTop = offset <= _headerSnapThresholdLow;
      final target = isToTop ? 0.0 : _headerSnapThresholdHigh;
      if ((offset - target).abs() < 4) return;

      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionCubit, AuthSessionState>(
      bloc: getIt<AuthSessionCubit>(),
      builder: (context, authState) {
        final isAnonymous = authState.isAnonymous;
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final isLoading = state.status == HomeStatus.initial || state.status == HomeStatus.loading;
            final isFailure = state.status == HomeStatus.failure;
            final lastLessonTitle = state.homeStats?.lastLessonCategory.trim() ?? '';
            final showRegisteredStatsSection = isLoading || lastLessonTitle.isNotEmpty;
            final staggerIndexBeforeBanners = isAnonymous || showRegisteredStatsSection ? 1 : 0;

            return Scaffold(
              backgroundColor: context.theme.scaffoldBackgroundColor,
              body: SafeArea(
                bottom: false,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeStarted());
                  },
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction == ScrollDirection.idle) {
                        _scheduleHeaderOverscrollSnap();
                      }
                      return false;
                    },
                    child: AppStaggeredScrollLimiter(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          StoryBarWidget(
                            scrollController: _scrollController,
                            isLoading: state.categoriesLoading,
                            list: state.categories,
                            onNotificationTap: () => onNotificationTap(context),
                            appBar: buildHeader(context, userGreetingName: state.userGreetingName),
                          ),
                          if (isFailure) ...[
                            if (isAnonymous) SliverToBoxAdapter(child: _staggeredSection(position: 0, child: buildGuestCard(context))),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: AppFailureState(message: context.l10n.homeLoadErrorMessage, onRetry: () => context.read<HomeBloc>().add(const HomeStarted())),
                            ),
                          ] else ...[
                            if (isAnonymous) SliverToBoxAdapter(child: _staggeredSection(position: 0, child: buildGuestCard(context))),
                            if (!isAnonymous && showRegisteredStatsSection) ...[
                              const SliverToBoxAdapter(child: SizedBox(height: 12)),
                              SliverToBoxAdapter(
                                child: _staggeredSection(
                                  position: 0,
                                  child: buildStatsSection(
                                    context,
                                    state.homeStats ?? _skeletonStats,
                                    isLoading: isLoading,
                                    onCoinsAndGradeTap: () {},
                                    onRatingTap: () => widget.onSwitchMainTab?.call(_mainTabLeaderboard),
                                    onLastLessonTap: () => context.push(Routes.myCourses),
                                  ),
                                ),
                              ),
                            ],
                            const SliverToBoxAdapter(child: SizedBox(height: 20)),
                            SliverToBoxAdapter(
                              child: _staggeredSection(
                                position: staggerIndexBeforeBanners,
                                child: buildBannersSection(context, isLoading ? _skeletonBanners : state.banners, isLoading: isLoading),
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 20)),
                            SliverToBoxAdapter(
                              child: _staggeredSection(
                                position: staggerIndexBeforeBanners + 1,
                                child: buildCoursesSection(context, isLoading ? _skeletonCourses : state.courses, isLoading: isLoading),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
