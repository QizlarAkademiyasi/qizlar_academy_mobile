import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_share_links.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/core/push/push_messaging_service.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/profile_badge_catalog_loader.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_badge_picker_sheet_content.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_filter_chips.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_header.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_language_option_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_delete_account_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_logout_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_menu_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_preference_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_section_card.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_stats_card.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_tez_kunda_sheet_content.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

mixin ProfileScreenMixin<T extends StatefulWidget> on State<T> {
  void profileBlocListener(BuildContext context, ProfileState state) {
    if (state.requiresRegistration) {
      context.go(Routes.register);
      return;
    }
    if (state.status != ProfileStatus.failure || state.overview == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.profilePreferenceUpdateError),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void retry(BuildContext context) {
    context.read<ProfileBloc>().add(const ProfileRetryRequested());
  }

  Future<void> onNotificationsChanged(
    BuildContext context,
    bool enabled,
  ) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_notifications_toggle',
      title: context.l10n.guestGateNotificationSettings,
    );
    if (!canExecute) return;
    if (!context.mounted) return;
    if (enabled) {
      final token = await getIt<PushMessagingService>()
          .ensureTokenForSubscribe();
      if (token == null || token.isEmpty) {
        if (context.mounted) {
          AppToast.warning(
            context,
            message: context.l10n.profileNotificationsEnableFailed,
          );
        }
        return;
      }
    }
    if (!context.mounted) return;
    context.read<ProfileBloc>().add(
      ProfileNotificationsToggled(enabled: enabled),
    );
  }

  Future<void> onDarkModeChanged(BuildContext context, bool enabled) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_darkmode_toggle',
      title: context.l10n.guestGateSaveSettings,
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
    if (item.type == ProfileMenuItemType.aboutApp) {
      context.push(Routes.aboutUs);
      return;
    }
    if (item.type == ProfileMenuItemType.privacyPolicy) {
      context.push(Routes.privacyPolicy);
      return;
    }
    if (item.type == ProfileMenuItemType.helpCenter) {
      final uri = Uri.tryParse(AppShareLinks.telegramGroup);
      if (uri == null) return;
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.aboutUsLinkOpenError),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
      return;
    }
    if (item.type == ProfileMenuItemType.shareApp) {
      await onShareApp(context);
      return;
    }

    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_menu_${item.id}',
      title: context.l10n.guestGateProfileFeatures,
    );
    if (!canExecute) return;
    if (!context.mounted) return;

    if (item.type == ProfileMenuItemType.myCourses) {
      context.push(Routes.myCourses);
      return;
    }
    if (item.type == ProfileMenuItemType.certificates) {
      context.push(Routes.myCertificates);
      return;
    }
    if (item.type == ProfileMenuItemType.vacancies) {
      context.push(Routes.vacancies);
      return;
    }
    if (item.type == ProfileMenuItemType.myActivity) {
      context.push(Routes.myActivity);
      return;
    }
    if (item.type == ProfileMenuItemType.profileInfo) {
      final saved = await context.push<bool?>(
        Routes.profileInformation,
        extra: overview.user,
      );
      if (!context.mounted) return;
      if (saved == true) {
        context.read<ProfileBloc>().add(const ProfileStarted());
        context.read<HomeBloc>().add(const HomeUserGreetingRefreshRequested());
      }
      return;
    }
    if (item.type == ProfileMenuItemType.language) {
      showLanguageBottomSheet(context, overview: overview);
      return;
    }
  }

  Future<void> onShareApp(BuildContext context) async {
    final message = context.l10n.profileShareAppMessage(
      AppShareLinks.storeOneLink,
    );
    await SharePlus.instance.share(ShareParams(text: message));
  }

  Future<void> showProfileTezKundaBottomSheet(BuildContext context) async {
    Gaimon.light();
    await showAppBottomSheet<void>(
      context,
      child: AppBottomSheetContainer(
        child: ProfileTezKundaSheetContent(
          title: context.l10n.profileTezKundaTitle,
          message: context.l10n.profileTezKundaMessage,
        ),
      ),
    );
  }

  Future<void> onProfileBadgePressed(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) async {
    final canExecute = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'profile_badge_picker',
      title: context.l10n.guestGateProfileFeatures,
    );
    if (!canExecute) return;
    if (!context.mounted) return;
    // Sheet route daraxtda [BlocProvider] dan tashqarida bo‘lishi mumkin; eventni shu ekranning bloc instansiyasiga yuboramiz.
    final profileBloc = context.read<ProfileBloc>();
    Gaimon.light();
    final catalog = await ProfileBadgeCatalogLoader.load();
    if (!context.mounted) return;
    if (catalog.isEmpty) return;
    final selectedId = ProfileBadgeCatalogLoader.coerceSelection(
      overview.user.badgeId,
      catalog,
    );
    await showAppBottomSheet<void>(
      context,
      child: AppBottomSheetContainer(
        title: context.l10n.profileBadgePickerTitle,
        headerGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.appColors.primary.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
        child: ProfileBadgePickerSheetContent(
          badges: catalog,
          selectedBadgeId: selectedId,
          onSelected: (id) {
            Navigator.of(context).pop();
            profileBloc.add(ProfileBadgeSelected(badgeId: id));
          },
        ),
      ),
    );
  }

  Future<void> showLanguageBottomSheet(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return showAppBottomSheet<void>(
      context,
      child: AppBottomSheetContainer(
        title: context.l10n.profileAppLanguageTitle,
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
              final displayOption = ProfileLanguageOptionModel(
                code: option.code,
                title: _languageOptionTitle(context, option.code),
                flagEmoji: option.flagEmoji,
              );
              return ProfileLanguageOptionTile(
                option: displayOption,
                isSelected: option.code == _appLanguageCode(context),
                showDivider: index != overview.languageOptions.length - 1,
                onTap: () {
                  onAppLanguageSelected(context, option: option);
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Ilova tili faqat [AppOptions] / [SettingsDataSource] orqali (localization), API yo‘q.
  void onAppLanguageSelected(
    BuildContext context, {
    required ProfileLanguageOptionModel option,
  }) {
    final opts = AppOptions.of(context);
    final target = L10n.localeFromProfileLanguageCode(option.code);
    if (opts.locale.languageCode == target.languageCode) return;
    AppOptions.update(context, opts.copyWith(locale: target));
  }

  String _appLanguageCode(BuildContext context) {
    return AppOptions.of(context).locale.languageCode.toLowerCase();
  }

  Future<void> onLogoutTap(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showAppPrimaryConfirmDialog(
      context,
      title: l10n.profileLogoutConfirmTitle,
      description: l10n.profileLogoutConfirmBody,
      cancelLabel: l10n.profileLogoutStay,
      confirmLabel: l10n.profileLogout,
      tgsAsset: UiKitAssets.lottie.rabbit.cryedRabbit,
      tgsSize: 120,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    Gaimon.light();
    await getIt<AuthSessionCubit>().continueAsGuest();
    getIt<GuestTapGateService>().reset();
    if (!context.mounted) return;
    context.go(Routes.main);
  }

  /// App Store 5.1.1(v): doimiy hisobni o‘chirish (server `DELETE /api/v1/user/me`).
  Future<void> onDeleteAccountTap(BuildContext context) async {
    final l10n = context.l10n;
    final webUrl = AppShareLinks.accountDeletionWebUrl;
    final step1 = await showAppPrimaryConfirmDialog(
      context,
      title: l10n.profileDeleteAccountTitle,
      description: l10n.profileDeleteAccountConfirmBody(webUrl),
      cancelLabel: l10n.profileDeleteAccountCancel,
      confirmLabel: l10n.profileDeleteAccountContinue,
      tgsAsset: UiKitAssets.lottie.rabbit.hmmmRabbit,
    );
    if (step1 != true) return;
    if (!context.mounted) return;
    final step2 = await showAppPrimaryConfirmDialog(
      context,
      title: l10n.profileDeleteAccountFinalTitle,
      description: l10n.profileDeleteAccountFinalBody,
      cancelLabel: l10n.profileDeleteAccountCancel,
      confirmLabel: l10n.profileDeleteAccountConfirmAction,
      tgsAsset: UiKitAssets.lottie.rabbit.cryedRabbit,
      tgsSize: 120,
    );
    if (step2 != true) return;
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                const SizedBox(width: 20),
                Expanded(child: Text(l10n.profileDeleteAccountProgress)),
              ],
            ),
          ),
        );
      },
    );
    try {
      await getIt<ProfileRepository>().deleteMyAccount();
    } catch (e, st) {
      AppLogger.w('deleteMyAccount failed', error: e, stackTrace: st);
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop<void>();
        AppToast.error(context, message: l10n.profileDeleteAccountError);
      }
      return;
    }
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop<void>();
    }
    getIt<GuestTapGateService>().reset();
    if (!context.mounted) return;
    Gaimon.light();
    context.go(Routes.signIn);
  }

  Widget buildDeleteAccountSection(BuildContext context) {
    return ProfileDeleteAccountTile(onTap: () => onDeleteAccountTap(context));
  }

  Widget buildProfileHeader(
    BuildContext context, {
    required ProfileOverviewModel overview,
    int avatarImageGeneration = 0,
    bool loading = false,
  }) {
    return ProfileHeader(
      user: overview.user,
      avatarImageGeneration: avatarImageGeneration,
      loading: loading,
      onBadgeTap: loading
          ? null
          : () => onProfileBadgePressed(context, overview: overview),
    );
  }

  Widget buildProfileStats(
    BuildContext context, {
    required ProfileOverviewModel overview,
    bool loading = false,
  }) {
    final l10n = context.l10n;
    final stats = <ProfileStatModel>[
      ProfileStatModel(
        value: '${overview.activeCoursesCount ?? 0}',
        label: l10n.profileStatCourses,
      ),
      ProfileStatModel(
        value: '${overview.certificatesCount ?? 0}',
        label: l10n.profileStatCertificates,
      ),
      ProfileStatModel(
        value: '${overview.rating ?? 0}',
        label: l10n.profileStatRating,
      ),
    ];
    return ProfileStatsCard(stats: stats, loading: loading);
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
      title: context.l10n.profileSectionAccount,
      children: List.generate(overview.achievements.length, (index) {
        final item = overview.achievements[index];
        return ProfileMenuTile(
          icon: _iconForMenuType(item.type),
          title: _profileMenuTitle(context, item),
          subtitle: _achievementSubtitle(context, overview, item),
          badgeCount: _achievementBadgeCount(overview, item),
          onTap: () {
            onMenuTap(context, item: item, overview: overview);
          },
          showDivider: index != overview.achievements.length - 1,
        );
      }),
    );
  }

  String? _achievementSubtitle(
    BuildContext context,
    ProfileOverviewModel overview,
    ProfileMenuItemModel item,
  ) {
    switch (item.type) {
      case ProfileMenuItemType.certificates:
        final n = overview.certificatesCount;
        if (n != null && n > 0) {
          return context.l10n.profileCertificatesCountSubtitle(n);
        }
        return item.subtitle;
      case ProfileMenuItemType.myCourses:
        final n = overview.activeCoursesCount;
        if (n != null && n > 0) {
          return context.l10n.profileActiveCoursesCountSubtitle(n);
        }
        return item.subtitle;
      case ProfileMenuItemType.myActivity:
        return item.subtitle;
      case ProfileMenuItemType.vacancies:
        return item.subtitle;
      default:
        return item.subtitle;
    }
  }

  int? _achievementBadgeCount(
    ProfileOverviewModel overview,
    ProfileMenuItemModel item,
  ) {
    if (item.type == ProfileMenuItemType.certificates) {
      final n = overview.certificatesCount;
      if (n != null && n > 0) return n;
    }
    return item.badgeCount;
  }

  Widget buildSettingsSection(
    BuildContext context, {
    required ProfileOverviewModel overview,
  }) {
    return ProfileSectionCard(
      title: context.l10n.profileSectionSettings,
      children: [
        ...List.generate(overview.settings.length, (index) {
          final item = overview.settings[index];
          return ProfileMenuTile(
            icon: _iconForMenuType(item.type),
            title: _profileMenuTitle(context, item),
            subtitle: item.type == ProfileMenuItemType.language
                ? _languageOptionTitle(context, _appLanguageCode(context))
                : item.subtitle,
            onTap: () {
              onMenuTap(context, item: item, overview: overview);
            },
            showDivider: true,
          );
        }),
        ProfilePreferenceTile(
          icon: LucideIcons.bell,
          title: context.l10n.profileNotifications,
          subtitle: context.l10n.profileNotificationsSubtitle,
          value: overview.notificationsEnabled,
          onChanged: (switchContext, enabled) =>
              onNotificationsChanged(context, enabled),
          showDivider: true,
        ),
        ProfilePreferenceTile(
          icon: LucideIcons.moon,
          title: context.l10n.profileDarkMode,
          subtitle: context.l10n.profileDarkModeSubtitle,
          value: isDarkModeEnabled(context),
          onChanged: (switchContext, enabled) {
            onDarkModeChanged(switchContext, enabled);
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
      title: context.l10n.profileSectionGeneral,
      children: List.generate(overview.general.length, (index) {
        final item = overview.general[index];
        return ProfileMenuTile(
          icon: _iconForMenuType(item.type),
          title: _profileMenuTitle(context, item),
          subtitle: item.type == ProfileMenuItemType.shareApp
              ? context.l10n.profileShareAppSubtitle
              : item.subtitle,
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

  String _profileMenuTitle(BuildContext context, ProfileMenuItemModel item) {
    final l = context.l10n;
    switch (item.type) {
      case ProfileMenuItemType.certificates:
        return l.profileMenuCertificates;
      case ProfileMenuItemType.myCourses:
        return l.profileMenuMyCourses;
      case ProfileMenuItemType.myActivity:
        return l.profileMenuMyActivity;
      case ProfileMenuItemType.vacancies:
        return l.profileMenuVacancies;
      case ProfileMenuItemType.profileInfo:
        return l.profileMenuProfileInfo;
      case ProfileMenuItemType.language:
        return l.profileMenuLanguage;
      case ProfileMenuItemType.shareApp:
        return l.profileMenuShareApp;
      case ProfileMenuItemType.aboutApp:
        return l.profileMenuAbout;
      case ProfileMenuItemType.helpCenter:
        return l.profileMenuHelp;
      case ProfileMenuItemType.privacyPolicy:
        return l.profileMenuPrivacy;
    }
  }

  String _languageOptionTitle(BuildContext context, String code) {
    final l = context.l10n;
    switch (code.toLowerCase()) {
      case 'ru':
        return l.languageRussian;
      case 'en':
        return l.languageEnglish;
      case 'uz':
      default:
        return l.languageUzbek;
    }
  }

  IconData _iconForMenuType(ProfileMenuItemType type) {
    switch (type) {
      case ProfileMenuItemType.certificates:
        return LucideIcons.file;
      case ProfileMenuItemType.myCourses:
        return LucideIcons.bookmark;
      case ProfileMenuItemType.myActivity:
        return LucideIcons.trendingUp;
      case ProfileMenuItemType.vacancies:
        return LucideIcons.briefcase;
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
