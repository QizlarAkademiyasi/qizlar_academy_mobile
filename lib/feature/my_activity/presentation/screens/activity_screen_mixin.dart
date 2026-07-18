import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_margin.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/repository/my_activity_repository.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/bloc/my_activity_bloc.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/components/activity_month_calendar_card.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/components/activity_screen_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/components/activity_stat_grid.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/components/activity_weekly_chart_card.dart';

mixin ActivityScreenMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final TabController _activityTabController;
  int _lastDispatchedTabIndex = 0;

  TabController get activityTabController => _activityTabController;

  void initActivityTabs() {
    _activityTabController = TabController(length: 2, vsync: this);
    _lastDispatchedTabIndex = _activityTabController.index;
    _activityTabController.addListener(_handleActivityTabIndexChanged);
  }

  void disposeActivityTabs() {
    _activityTabController.removeListener(_handleActivityTabIndexChanged);
    _activityTabController.dispose();
  }

  void _handleActivityTabIndexChanged() {
    final index = _activityTabController.index;
    if (index == _lastDispatchedTabIndex) return;

    _lastDispatchedTabIndex = index;
    final scope = index == 0
        ? MyActivityStatsScope.weekly
        : MyActivityStatsScope.monthly;
    context.read<MyActivityBloc>().add(MyActivityScopeChanged(scope));
  }

  Widget buildActivityTabs(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: AppMargin.pageHorizontal,
      child: AppSegmentedTabBar(
        controller: _activityTabController,
        tabLabels: [l10n.activityTabWeekly, l10n.activityTabMonthly],
      ),
    );
  }

  Widget buildActivityMainBody(BuildContext context, MyActivityState state) {
    return TabBarView(
      controller: _activityTabController,
      children: [
        _buildActivityScopeBody(
          context: context,
          state: state,
          scope: MyActivityStatsScope.weekly,
        ),
        _buildActivityScopeBody(
          context: context,
          state: state,
          scope: MyActivityStatsScope.monthly,
        ),
      ],
    );
  }

  Widget _buildActivityScopeBody({
    required BuildContext context,
    required MyActivityState state,
    required MyActivityStatsScope scope,
  }) {
    final stats = scope == MyActivityStatsScope.weekly
        ? state.weekly
        : state.monthly;

    if (state.status == MyActivityStatus.loading && stats == null) {
      return ActivityScreenLoadingBody(scope: scope);
    }

    if (state.status == MyActivityStatus.failure || stats == null) {
      return Padding(
        padding: AppMargin.pageHorizontal,
        child: AppFailureState(
          message: context.l10n.activityLoadError,
          onRetry: () => context.read<MyActivityBloc>().add(
            const MyActivityRetryRequested(),
          ),
        ),
      );
    }

    final chart = scope == MyActivityStatsScope.weekly
        ? ActivityWeeklyChartCard(stats: stats)
        : ActivityMonthCalendarCard(stats: stats);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      children: [
        chart,
        const SizedBox(height: 22),
        Text(
          context.l10n.activitySectionStats,
          style: context.textTheme.bodyLargeBold.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ActivityStatGrid(stats: stats),
      ],
    );
  }
}
