import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/bloc/notification_settings_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/components/notification_settings_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/components/notification_settings_switch_tile.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/notification_settings_screen_mixin.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key, this.masterEnabled});

  final bool? masterEnabled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationSettingsBloc>()
        ..add(NotificationSettingsStarted(masterEnabled: masterEnabled)),
      child: const _NotificationSettingsView(),
    );
  }
}

class _NotificationSettingsView extends StatefulWidget {
  const _NotificationSettingsView();

  @override
  State<_NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<_NotificationSettingsView>
    with NotificationSettingsScreenMixin<_NotificationSettingsView> {
  bool _onScrollNotification(ScrollNotification n, BuildContext context) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) {
      return false;
    }
    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 220) {
      onScrollNearEnd(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: context.l10n.notificationSettingsTitle,
      onBackTap: () => onBackTap(context),
      body: BlocConsumer<NotificationSettingsBloc, NotificationSettingsState>(
        listener: notificationSettingsBlocListener,
        builder: (context, state) {
          return switch (state.status) {
            NotificationSettingsStatus.failure when state.topics.isEmpty =>
              TgsFailureContent(
                message: context.l10n.notificationSettingsLoadError,
                onRetry: () => retry(context),
              ),
            NotificationSettingsStatus.initial ||
            NotificationSettingsStatus.loading
                when state.topics.isEmpty =>
              const NotificationSettingsSkeleton(),
            _ => NotificationListener<ScrollNotification>(
              onNotification: (n) => _onScrollNotification(n, context),
              child: ListView(
                padding: AppPadding.paddingHorizontalXl.add(
                  EdgeInsets.only(
                    top: 8,
                    bottom: 28 + MediaQuery.paddingOf(context).bottom,
                  ),
                ),
                children: [
                  NotificationSettingsSwitchTile(
                    key: const ValueKey('notification-master-switch'),
                    title: context.l10n.notificationSettingsMasterTitle,
                    subtitle: context.l10n.notificationSettingsMasterSubtitle,
                    value: state.masterEnabled,
                    onChanged: (enabled) => onMasterChanged(context, enabled),
                    showDivider: false,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.notificationSettingsTopicsTitle,
                    style: context.textTheme.bodySmallBold.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                  ),
                  if (!state.masterEnabled) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.notificationSettingsTopicsDisabled,
                      style: context.textTheme.bodySmallRegular.copyWith(
                        color: context.appColors.secondaryGrey,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (state.topics.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: TgsEmptyContent(
                        message: context.l10n.notificationSettingsEmpty,
                        subtitle:
                            context.l10n.notificationSettingsEmptySubtitle,
                        tgsAsset: UiKitAssets.lottie.rabbit.sleepRabbit,
                        animationSize: 112,
                      ),
                    )
                  else
                    ...List.generate(state.topics.length, (index) {
                      final topic = state.topics[index];
                      return NotificationSettingsSwitchTile(
                        key: ValueKey('notification-topic-switch-${topic.id}'),
                        title: topic.topic,
                        value: topic.isSubscribed,
                        enabled: state.masterEnabled,
                        onChanged: (enabled) =>
                            onTopicChanged(context, topic.id, enabled),
                        showDivider: index != state.topics.length - 1,
                      );
                    }),
                  if (state.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: SizedBox(
                        height: 80,
                        child: NotificationSettingsSkeleton(),
                      ),
                    ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
