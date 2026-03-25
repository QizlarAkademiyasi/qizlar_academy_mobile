import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_filter_chips.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_header.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_language_option_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_logout_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_menu_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_preference_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_section_card.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_stats_card.dart';

mixin ProfileScreenMixin<T extends StatefulWidget> on State<T> {
  void profileBlocListener(BuildContext context, ProfileState state) {
    if (state.requiresRegistration) {
      context.go(Routes.register);
      return;
    }
    if (state.status != ProfileStatus.failure || state.message == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(state.message!),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void retry(BuildContext context) {
    context.read<ProfileBloc>().add(const ProfileRetryRequested());
  }

  Future<void> onNotificationsChanged(BuildContext context, bool enabled) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_notifications_toggle',
      title: 'Bildirishnoma sozlamalari uchun ro‘yxatdan o‘ting',
    );
    if (!canExecute) return;
    if (!context.mounted) return;
    context.read<ProfileBloc>().add(
      ProfileNotificationsToggled(enabled: enabled),
    );
  }

  Future<void> onDarkModeChanged(BuildContext context, bool enabled) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_darkmode_toggle',
      title: 'Sozlamalarni saqlash uchun ro‘yxatdan o‘ting',
    );
    if (!canExecute) return;
    if (!context.mounted) return;
    final appOptions = AppOptions.of(context);
    final targetMode = enabled ? ThemeMode.dark : ThemeMode.light;
    if (appOptions.themeMode == targetMode) return;

    void toggleTheme() {
      AppOptions.update(context, appOptions.copyWith(themeMode: targetMode));
    }

    final animation = ThemeCircleAnimation.of(context);
    if (animation == null) {
      toggleTheme();
      return;
    }

    animation.toggleFromWidget(context: context, onToggle: toggleTheme);
  }

  bool isDarkModeEnabled(BuildContext context) {
    final appOptions = AppOptions.of(context);
    switch (appOptions.themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  Future<void> onMenuTap(
    BuildContext context, {
    required ProfileMenuItemModel item,
    required ProfileOverviewModel overview,
  }) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_menu_${item.id}',
      title: 'Profil funksiyalari uchun ro‘yxatdan o‘ting',
    );
    if (!canExecute) return;
    if (!context.mounted) return;

    if (item.type == ProfileMenuItemType.language) {
      showLanguageBottomSheet(context, overview: overview);
      return;
    }
  }

  Future<void> showLanguageBottomSheet(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return showAppBottomSheet<void>(
      context,
      child: AppBottomSheetContainer(
        title: 'Ilova tili',
        headerGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.appColors.primary.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusXl,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(overview.languageOptions.length, (index) {
              final option = overview.languageOptions[index];
              return ProfileLanguageOptionTile(
                option: option,
                isSelected: option.code == overview.selectedLanguageCode,
                showDivider: index != overview.languageOptions.length - 1,
                onTap: () {
                  onLanguageChanged(
                    context,
                    option: option,
                    overview: overview,
                  );
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  void onLanguageChanged(
    BuildContext context, {
    required ProfileLanguageOptionModel option,
    required ProfileOverviewModel overview,
  }) {
    if (option.code == overview.selectedLanguageCode) return;
    context.read<ProfileBloc>().add(ProfileLanguageChanged(code: option.code));
  }

  Future<void> onLogoutTap(BuildContext context) async {
    Gaimon.light();
    await getIt<AuthSessionCubit>().continueAsGuest();
    getIt<GuestTapGateService>().reset();
    if (!context.mounted) return;
    context.go(Routes.main);
  }

  Widget buildProfileHeader(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileHeader(user: overview.user);
  }

  Widget buildProfileStats(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileStatsCard(stats: overview.stats);
  }

  Widget buildProfileFilters(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileFilterChips(items: overview.bankFilters);
  }

  Widget buildAchievementsSection(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileSectionCard(
      title: 'HISOB',
      children: List.generate(overview.achievements.length, (index) {
        final item = overview.achievements[index];
        return ProfileMenuTile(
          icon: _iconForMenuType(item.type),
          title: item.title,
          subtitle: item.subtitle,
          badgeCount: item.badgeCount,
          onTap: () {
            onMenuTap(context, item: item, overview: overview);
          },
          showDivider: index != overview.achievements.length - 1,
        );
      }),
    );
  }

  Widget buildSettingsSection(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileSectionCard(
      title: 'SOZLAMALAR',
      children: [
        ...List.generate(overview.settings.length, (index) {
          final item = overview.settings[index];
          return ProfileMenuTile(
            icon: _iconForMenuType(item.type),
            title: item.title,
            subtitle: item.subtitle,
            onTap: () {
              onMenuTap(context, item: item, overview: overview);
            },
            showDivider: true,
          );
        }),
        ProfilePreferenceTile(
          icon: LucideIcons.bell,
          title: 'Bildirishnomalar',
          subtitle: 'Push-xabarlar',
          value: overview.notificationsEnabled,
          onChanged: (switchContext, enabled) =>
              onNotificationsChanged(context, enabled),
          showDivider: true,
        ),
        ProfilePreferenceTile(
          icon: LucideIcons.moon,
          title: 'Tungi rejim',
          subtitle: 'Qorong\'i interfeys',
          value: isDarkModeEnabled(context),
          onChanged: (switchContext, enabled) {
            onDarkModeChanged(context, enabled);
          },
          showDivider: false,
        ),
      ],
    );
  }

  Widget buildGeneralSection(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileSectionCard(
      title: 'UMUMIY',
      children: List.generate(overview.general.length, (index) {
        final item = overview.general[index];
        return ProfileMenuTile(
          icon: _iconForMenuType(item.type),
          title: item.title,
          subtitle: item.subtitle,
          onTap: () {
            onMenuTap(context, item: item, overview: overview);
          },
          showDivider: index != overview.general.length - 1,
        );
      }),
    );
  }

  Widget buildLogoutSection(BuildContext context) {
    return ProfileLogoutTile(onTap: () => onLogoutTap(context));
  }

  IconData _iconForMenuType(ProfileMenuItemType type) {
    switch (type) {
      case ProfileMenuItemType.certificates:
        return LucideIcons.file;
      case ProfileMenuItemType.myCourses:
        return LucideIcons.bookmark;
      case ProfileMenuItemType.myActivity:
        return LucideIcons.trendingUp;
      case ProfileMenuItemType.profileInfo:
        return LucideIcons.userRound;
      case ProfileMenuItemType.language:
        return LucideIcons.languages;
      case ProfileMenuItemType.shareApp:
        return LucideIcons.share2;
      case ProfileMenuItemType.aboutApp:
        return LucideIcons.info;
      case ProfileMenuItemType.helpCenter:
        return LucideIcons.circleQuestionMark;
      case ProfileMenuItemType.privacyPolicy:
        return LucideIcons.shieldCheck;
    }
  }
}
