import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/bloc/notification_settings_bloc.dart';

mixin NotificationSettingsScreenMixin<T extends StatefulWidget> on State<T> {
  int _lastUpdateFailureVersion = 0;

  void notificationSettingsBlocListener(
    BuildContext context,
    NotificationSettingsState state,
  ) {
    if (state.updateFailureVersion == _lastUpdateFailureVersion) return;
    _lastUpdateFailureVersion = state.updateFailureVersion;
    AppToast.error(
      context,
      message: context.l10n.notificationSettingsUpdateError,
    );
  }

  void retry(BuildContext context) {
    context.read<NotificationSettingsBloc>().add(
      const NotificationSettingsRetryRequested(),
    );
  }

  void onBackTap(BuildContext context) {
    context.pop();
  }

  void onMasterChanged(BuildContext context, bool enabled) {
    context.read<NotificationSettingsBloc>().add(
      NotificationSettingsMasterToggled(enabled: enabled),
    );
  }

  void onTopicChanged(BuildContext context, String topicId, bool enabled) {
    context.read<NotificationSettingsBloc>().add(
      NotificationSettingsTopicToggled(topicId: topicId, enabled: enabled),
    );
  }

  void onScrollNearEnd(BuildContext context) {
    context.read<NotificationSettingsBloc>().add(
      const NotificationSettingsLoadMoreRequested(),
    );
  }
}
