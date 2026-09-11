import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/notification_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/utils/notification_grouping.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NotificationBloc>()..add(const NotificationStarted()),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatefulWidget {
  const _NotificationView();

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView>
    with
        NotificationScreenMixin<_NotificationView>,
        SingleTickerProviderStateMixin {
  static const Duration _pageAnimationDuration = Duration(milliseconds: 280);

  late final TabController _tabController;
  late final PageController _pageController;

  static int _indexForTab(NotificationListTab tab) =>
      tab == NotificationListTab.platform ? 0 : 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(
    ScrollNotification n,
    BuildContext context,
    NotificationListTab tab,
  ) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) {
      return false;
    }
    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 220) {
      onScrollNearEnd(context, tab);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        notificationBlocListener(context, state);
        final target = _indexForTab(state.selectedTab);
        if (_tabController.index != target) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (_tabController.index != target) {
              _tabController.animateTo(target);
            }
          });
        }
        if (_pageController.hasClients) {
          final page = _pageController.page;
          final current = page != null
              ? page.round()
              : _pageController.initialPage;
          if (current != target) {
            _pageController.animateToPage(
              target,
              duration: _pageAnimationDuration,
              curve: Curves.easeOutCubic,
            );
          }
        }
      },
      builder: (context, state) {
        return AppPageScaffold(
          title: context.l10n.notificationsTitle,
          onBackTap: () => onBackTap(context),
          actions: [
            IconButton(
              onPressed: state.hasUnread ? () => onMarkAllTap(context) : null,
              icon: Icon(
                LucideIcons.checkCheck,
                color: state.hasUnread
                    ? context.appColors.text
                    : context.appColors.secondaryGrey,
              ),
            ),
          ],
          body: Column(
            children: [
              Padding(
                padding: AppPadding.paddingHorizontalXl.add(
                  const EdgeInsets.only(bottom: 12),
                ),
                child: buildNotificationTabs(context, _tabController),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    final tab = index == 0
                        ? NotificationListTab.platform
                        : NotificationListTab.community;
                    if (!context.mounted) return;
                    if (context.read<NotificationBloc>().state.selectedTab ==
                        tab) {
                      return;
                    }
                    context.read<NotificationBloc>().add(
                      NotificationTabSelected(tab),
                    );
                    if (_tabController.index != index) {
                      _tabController.animateTo(index);
                    }
                  },
                  children: [
                    _KeepAliveTabWrapper(
                      child: _buildTabBody(
                        context,
                        state,
                        NotificationListTab.platform,
                      ),
                    ),
                    _KeepAliveTabWrapper(
                      child: _buildTabBody(
                        context,
                        state,
                        NotificationListTab.community,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBody(
    BuildContext context,
    NotificationState state,
    NotificationListTab tab,
  ) {
    final data = state.dataFor(tab);
    if (data.isInitialLoading || data.status == NotificationTabStatus.initial) {
      return const Padding(
        padding: EdgeInsets.only(top: 6),
        child: NotificationListSkeleton(),
      );
    }
    if (data.status == NotificationTabStatus.failure && data.items.isEmpty) {
      return TgsFailureContent(
        message: context.l10n.notificationListLoadError,
        onRetry: () => retry(context, tab),
      );
    }
    if (data.items.isEmpty) {
      return NotificationEmptyContent(
        message: context.l10n.notificationsEmptyThisTab,
        subtitle: context.l10n.notificationsEmptyThisTabSubtitle,
      );
    }

    final sections = groupNotificationItems(data.items, context.l10n);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) => _onScrollNotification(n, context, tab),
      child: AppStaggeredScrollLimiter(
        child: CustomScrollView(
          key: PageStorageKey<String>('notification_scroll_${tab.name}'),
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 28 + bottomInset),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == sections.length * 2 - 1 &&
                        data.isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: SizedBox(
                          height: 72,
                          child: NotificationListSkeleton(),
                        ),
                      );
                    }
                    if (index.isOdd) return const SizedBox(height: 28);
                    final sectionIndex = index ~/ 2;
                    if (sectionIndex >= sections.length) {
                      return const SizedBox.shrink();
                    }
                    final section = sections[sectionIndex];
                    var staggerStart = 0;
                    for (var i = 0; i < sectionIndex; i++) {
                      staggerStart += sections[i].items.length;
                    }
                    return buildSection(
                      context,
                      section: section,
                      staggerStartIndex: staggerStart,
                    );
                  },
                  childCount:
                      sections.length * 2 - 1 + (data.isLoadingMore ? 1 : 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeepAliveTabWrapper extends StatefulWidget {
  const _KeepAliveTabWrapper({required this.child});

  final Widget child;

  @override
  State<_KeepAliveTabWrapper> createState() => _KeepAliveTabWrapperState();
}

class _KeepAliveTabWrapperState extends State<_KeepAliveTabWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
