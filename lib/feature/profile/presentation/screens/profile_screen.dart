import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_ambient_background.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/services/profile_avatar_refresh_notifier.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_app_version_text.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/profile_screen_mixin.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [ProfileBloc] [app_routes] dagi [MainScreen] ota-providers orqali beriladi (faqat [mainUser]).
    return const _ProfileView();
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with ProfileScreenMixin<_ProfileView> {
  ProfileOverviewModel _skeletonOverview(BuildContext context) {
    final l10n = context.l10n;
    return ProfileOverviewModel(
      user: const ProfileUserModel(
        firstName: '---',
        lastName: '-------',
        fullName: '--- -------',
        userId: '------',
        phoneNumber: '+998901234567',
        avatarUrl: '',
        badgeId: 0,
      ),
      stats: const [],
      bankFilters: const [],
      achievements: kDefaultProfileAchievementItems,
      certificatesCount: null,
      activeCoursesCount: null,
      rating: null,
      settings: [
        ProfileMenuItemModel(
          id: 'settings-1',
          type: ProfileMenuItemType.profileInfo,
          title: l10n.profileMenuProfileInfo,
        ),
        ProfileMenuItemModel(
          id: 'settings-2',
          type: ProfileMenuItemType.language,
          title: l10n.profileMenuLanguage,
          subtitle: '---',
        ),
      ],
      general: [
        ProfileMenuItemModel(
          id: 'general-1',
          type: ProfileMenuItemType.shareApp,
          title: l10n.profileMenuShareApp,
          subtitle: l10n.profileShareAppSubtitle,
        ),
        ProfileMenuItemModel(
          id: 'general-invite',
          type: ProfileMenuItemType.inviteFriend,
          title: l10n.profileMenuInviteFriend,
          subtitle: l10n.profileInviteFriendSubtitle,
        ),
        ProfileMenuItemModel(
          id: 'general-2',
          type: ProfileMenuItemType.aboutApp,
          title: l10n.profileMenuAbout,
        ),
        ProfileMenuItemModel(
          id: 'general-3',
          type: ProfileMenuItemType.helpCenter,
          title: l10n.profileMenuHelp,
          subtitle: '---',
        ),
        ProfileMenuItemModel(
          id: 'general-4',
          type: ProfileMenuItemType.privacyPolicy,
          title: l10n.profileMenuPrivacy,
        ),
      ],
      languageOptions: [
        ProfileLanguageOptionModel(
          code: 'uz',
          title: l10n.languageUzbek,
          flagEmoji: '🇺🇿',
        ),
        ProfileLanguageOptionModel(
          code: 'ru',
          title: l10n.languageRussian,
          flagEmoji: '🇷🇺',
        ),
        ProfileLanguageOptionModel(
          code: 'en',
          title: l10n.languageEnglish,
          flagEmoji: '🇬🇧',
        ),
      ],
      selectedLanguageCode: 'uz',
      notificationsEnabled: false,
      darkModeEnabled: false,
      versionName: '...',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: context.isDarkTheme
          ? context.appColors.background
          : const Color(0xFFF7F7F5),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: profileBlocListener,
        builder: (context, state) {
          final isInitialLoading =
              (state.status == ProfileStatus.loading ||
                  state.status == ProfileStatus.initial) &&
              state.overview == null;

          if (state.requiresRegistration) {
            return const SizedBox.shrink();
          }
          if (state.overview == null && !isInitialLoading) {
            return AppFailureState(
              message: l10n.profileOverviewLoadError,
              onRetry: () => retry(context),
            );
          }
          final overview = state.overview ?? _skeletonOverview(context);

          final bottomInset = MediaQuery.paddingOf(context).bottom;
          return ListenableBuilder(
            listenable: getIt<ProfileAvatarRefreshNotifier>(),
            builder: (context, _) {
              final avatarGen =
                  getIt<ProfileAvatarRefreshNotifier>().generation;
              final topInset = MediaQuery.paddingOf(context).top;
              return Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HomeAmbientBackground(),
                  ),
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            topInset + 8,
                            24,
                            14,
                          ),
                          child: Skeletonizer.zone(
                            enabled: isInitialLoading,
                            child: buildProfileHeader(
                              context,
                              overview: overview,
                              avatarImageGeneration: avatarGen,
                              loading: isInitialLoading,
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, bottomInset + 56),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Skeletonizer.zone(
                              enabled: isInitialLoading,
                              child: IgnorePointer(
                                ignoring: isInitialLoading,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: buildProfileStats(
                                        context,
                                        overview: overview,
                                        loading: isInitialLoading,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: buildPartnersSection(context),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: buildAchievementsSection(
                                        context,
                                        overview: overview,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: buildSettingsSection(
                                        context,
                                        overview: overview,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: buildGeneralSection(
                                        context,
                                        overview: overview,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: buildDeleteAccountSection(context),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: buildLogoutSection(context),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: ProfileAppVersionText(
                                style: context.textTheme.bodySmallRegular
                                    .copyWith(
                                      color: context.appColors.secondaryGrey,
                                    ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
