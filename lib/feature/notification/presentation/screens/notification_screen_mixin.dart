import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_detail_sheet.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_section.dart';

mixin NotificationScreenMixin<T extends StatefulWidget> on State<T> {
  Widget buildNotificationTabs(
    BuildContext context,
    TabController controller,
  ) => AppSegmentedTabBar(
    controller: controller,
    tabLabels: [
      context.l10n.notificationTabPlatform,
      context.l10n.notificationTabCommunity,
    ],
    onTap: (index) => context.read<NotificationBloc>().add(
      NotificationTabSelected(
        index == 0
            ? NotificationListTab.platform
            : NotificationListTab.community,
      ),
    ),
  );

  int _lastActionFailureVersion = 0;
  int _lastLoadMoreFailureVersion = 0;

  void notificationBlocListener(BuildContext context, NotificationState state) {
    if (state.actionFailureVersion != _lastActionFailureVersion) {
      _lastActionFailureVersion = state.actionFailureVersion;
      AppToast.error(context, message: context.l10n.notificationActionError);
    }
    if (state.loadMoreFailureVersion != _lastLoadMoreFailureVersion) {
      _lastLoadMoreFailureVersion = state.loadMoreFailureVersion;
      AppToast.error(context, message: context.l10n.notificationActionError);
    }
  }

  void retry(BuildContext context, NotificationListTab tab) {
    context.read<NotificationBloc>().add(NotificationRetryRequested(tab: tab));
  }

  void onBackTap(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.main);
  }

  Future<void> onMarkAllTap(BuildContext context) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'notification_mark_all',
      title: context.l10n.guestGateMarkAllRead,
    );
    if (!canExecute) return;
    if (!context.mounted) return;
    context.read<NotificationBloc>().add(
      const NotificationMarkAllReadRequested(),
    );
    Gaimon.light();
  }

  void onScrollNearEnd(BuildContext context, NotificationListTab tab) {
    context.read<NotificationBloc>().add(NotificationLoadMoreRequested(tab));
  }

  Future<void> onNotificationTap(
    BuildContext context,
    NotificationItemModel item,
  ) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'notification_item_${item.id}',
      title: context.l10n.guestGateManageNotifications,
    );
    if (!canExecute) return;
    if (!context.mounted) return;
    Gaimon.selection();
    if (!item.isRead) {
      context.read<NotificationBloc>().add(
        NotificationItemOpened(notificationId: item.id),
      );
    }
    if (item.isPostActivity) {
      final postId = item.destinationPostId;
      if (postId != null) {
        context.push(Routes.portfolioDetailPath(postId));
      }
      return;
    }
    await showNotificationDetailSheet(
      context,
      item: item,
      onCta: () {
        Navigator.of(context).maybePop();
        final targetId = item.targetId?.trim() ?? '';
        if (targetId.isEmpty) return;
        context.push(Routes.courseDetails(targetId));
      },
    );
  }

  Widget buildSection(
    BuildContext context, {
    required NotificationSectionModel section,
    required int staggerStartIndex,
  }) {
    return NotificationSection(
      section: section,
      staggerStartIndex: staggerStartIndex,
      onItemTap: (item) {
        onNotificationTap(context, item);
      },
    );
  }
}
