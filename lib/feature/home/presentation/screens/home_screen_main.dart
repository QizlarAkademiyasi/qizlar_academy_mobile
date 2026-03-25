import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_state.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/story_bar_widget.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/home_screen_mixin.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with HomeScreenMixin<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  static const List<StoryModel> _skeletonCategories = [
    StoryModel(id: 's1', name: 'Arab tili', imageUrl: '', thumbnailUrl: ''),
    StoryModel(id: 's2', name: 'Tikuvchilik', imageUrl: '', thumbnailUrl: ''),
    StoryModel(id: 's3', name: 'Pazandachilik', imageUrl: '', thumbnailUrl: ''),
    StoryModel(id: 's4', name: 'Psixologiya', imageUrl: '', thumbnailUrl: ''),
  ];
  static const HomeStatsModel _skeletonStats = HomeStatsModel(
    coins: 1200,
    grade: 12,
    rating: 8,
    lastLessonCategory: 'Arab tili',
    lastLessonProgress: 0.6,
  );
  static const List<CourseModel> _skeletonCourses = [
    CourseModel(
      id: 'c1',
      title: 'Arab tiliga kirish',
      author: 'Mentor',
      imageUrl: '',
      durationHours: 24,
      studentCount: 1000,
    ),
    CourseModel(
      id: 'c2',
      title: 'Ayollar psixologiyasi',
      author: 'Mentor',
      imageUrl: '',
      durationHours: 16,
      studentCount: 740,
    ),
  ];
  static const List<BannerModel> _skeletonBanners = [
    BannerModel(
      id: 'b1',
      title: 'Skleton Banner Titli',
      subtitle: 'Skleton Banner uzunroq matni',
      imageUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionCubit, AuthSessionState>(
      bloc: getIt<AuthSessionCubit>(),
      builder: (context, authState) {
        final isAnonymous = authState.isAnonymous;
        return BlocConsumer<HomeBloc, HomeState>(
          listener: homeBlocListener,
          builder: (context, state) {
            final isLoading =
                state.status == HomeStatus.initial ||
                state.status == HomeStatus.loading;

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
                      bool shouldAnimate =
                          _scrollController.hasClients &&
                          _scrollController.offset.isFinite &&
                          _scrollController.offset <= 1.8 * kToolbarHeight;
                      if (!shouldAnimate) return false;
                      if (notification.direction == ScrollDirection.idle) {
                        bool isToTop =
                            _scrollController.offset <= 0.8 * kToolbarHeight;
                        _scrollController.animateTo(
                          isToTop ? 0 : 1.8 * kToolbarHeight,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        StoryBarWidget(
                          scrollController: _scrollController,
                          isLoading: isLoading,
                          list: isLoading ? _skeletonCategories : state.categories,
                          appBar: buildHeader(context, resolveUserName()),
                        ),
                        if (isAnonymous)
                          SliverToBoxAdapter(
                            child: buildGuestCard(context),
                          ),
                        if (!isAnonymous) ...[
                          const SliverToBoxAdapter(child: SizedBox(height: 12)),
                          SliverToBoxAdapter(
                            child: buildStatsSection(
                              context,
                              state.homeStats ?? _skeletonStats,
                              isLoading: isLoading,
                            ),
                          ),
                        ],
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(
                          child: buildBannersSection(
                            context,
                            isLoading ? _skeletonBanners : state.banners,
                            isLoading: isLoading,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(
                          child: buildCoursesSection(
                            context,
                            isLoading ? _skeletonCourses : state.courses,
                            isLoading: isLoading,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
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
