import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/portfolio_screen_mixin.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PortfolioBloc>()..add(const PortfolioStarted()),
      child: const _PortfolioView(),
    );
  }
}

class _PortfolioView extends StatefulWidget {
  const _PortfolioView();

  @override
  State<_PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<_PortfolioView>
    with PortfolioScreenMixin<_PortfolioView>, SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: PortfolioFeedTab.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification is! ScrollUpdateNotification &&
        notification is! OverscrollNotification) {
      return false;
    }
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 240) {
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
        child: BlocConsumer<PortfolioBloc, PortfolioState>(
          listenWhen: (previous, current) =>
              current.loadMoreFailed && !previous.loadMoreFailed ||
              current.authRequired && !previous.authRequired ||
              current.message != null && current.message != previous.message,
          listener: (context, state) {
            portfolioBlocListener(context, state);
            if (_tabController.index != state.tab.index) {
              _tabController.animateTo(state.tab.index);
            }
          },
          builder: (context, state) {
            final isInitialLoading =
                (state.status == PortfolioStatus.initial ||
                    state.status == PortfolioStatus.loading) &&
                state.items.isEmpty;
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                      child: Row(
                        children: [
                          AppBackButton.ghost(onTap: () => onBackTap(context)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Portfolio',
                              style: context.textTheme.heading5.copyWith(
                                color: context.appColors.text,
                              ),
                            ),
                          ),
                          if (!state.isGuest)
                            IconButton(
                              onPressed: () => onCreateTap(context, state),
                              icon: const Icon(LucideIcons.circlePlus),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AppSegmentedTabBar(
                        controller: _tabController,
                        tabLabels: const ['Barchasi', 'Mening loyihalarim'],
                        onTap: (index) => onTabChanged(
                          context,
                          PortfolioFeedTab.values[index],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: switch (state.status) {
                        PortfolioStatus.failure when state.items.isEmpty =>
                          TgsFailureContent(
                            message:
                                'Portfolio yuklanmadi. Qayta urinib ko\'ring.',
                            onRetry: () => context.read<PortfolioBloc>().add(
                              const PortfolioRetryRequested(),
                            ),
                          ),
                        _ when isInitialLoading =>
                          const PortfolioListSkeleton(),
                        PortfolioStatus.success when state.items.isEmpty =>
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: TgsEmptyContent(
                                message: 'Portfolio hali bo\'sh',
                                subtitle:
                                    'Yangi loyihalar paydo bo\'lganda shu yerda ko\'rasiz.',
                              ),
                            ),
                          ),
                        _ => NotificationListener<ScrollNotification>(
                          onNotification: (n) =>
                              _onScrollNotification(n, context),
                          child: AppStaggeredScrollLimiter(
                            child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.fromLTRB(
                                    24,
                                    4,
                                    24,
                                    bottomInset + 112,
                                  ),
                                  sliver: SliverList.separated(
                                    itemBuilder: (context, index) {
                                      if (index >= state.items.length) {
                                        return Skeletonizer.zone(
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: Center(
                                              child: Bone.text(words: 4),
                                            ),
                                          ),
                                        );
                                      }
                                      return AppStaggeredListItem(
                                        position: index,
                                        child: buildPostCard(
                                          context,
                                          state.items[index],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (_, _) => Divider(
                                      height: 30,
                                      thickness: 2,
                                      color: context.appColors.stroke,
                                    ),
                                    itemCount:
                                        state.items.length +
                                        (state.isLoadingMore ? 1 : 0),
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
                  child: context.isDarkTheme
                      ? UiKitAssets.images.bottomNavDark.image(
                          fit: BoxFit.cover,
                        )
                      : UiKitAssets.images.bottomNavLight.image(
                          fit: BoxFit.cover,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
