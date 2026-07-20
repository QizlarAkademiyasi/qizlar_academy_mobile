import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_detail_sheet.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_section.dart';

mixin NotificationScreenMixin<T extends StatefulWidget> on State<T> {
  void notificationBlocListener(BuildContext context, NotificationState state) {
    if (state.status != NotificationStatus.failure || state.sections.isEmpty) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.notificationActionError),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void retry(BuildContext context) {
    context.read<NotificationBloc>().add(const NotificationRetryRequested());
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
    await showNotificationDetailSheet(
      context,
      item: item,
      detailsLabel: context.l10n.notificationDetailsMore,
    );
    if (!context.mounted) return;
    if (!item.isRead) {
      context.read<NotificationBloc>().add(
        NotificationItemOpened(notificationId: item.id),
      );
    }
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
