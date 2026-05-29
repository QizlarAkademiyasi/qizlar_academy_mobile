import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/format/phone_display_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_full_name_with_badge.dart';
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

class _ProfileViewState extends State<_ProfileView> with ProfileScreenMixin<_ProfileView> {
  ProfileOverviewModel _skeletonOverview(BuildContext context) {
    final l10n = context.l10n;
    return ProfileOverviewModel(
      user: const ProfileUserModel(firstName: '---', lastName: '-------', fullName: '--- -------', userId: '------', phoneNumber: '+998901234567', avatarUrl: '', badgeId: 0),
      stats: const [],
      bankFilters: const [],
      achievements: kDefaultProfileAchievementItems,
      certificatesCount: null,
      activeCoursesCount: null,
      rating: null,
      settings: [
        ProfileMenuItemModel(id: 'settings-1', type: ProfileMenuItemType.profileInfo, title: l10n.profileMenuProfileInfo),
        ProfileMenuItemModel(id: 'settings-2', type: ProfileMenuItemType.language, title: l10n.profileMenuLanguage, subtitle: '---'),
      ],
      general: [
        ProfileMenuItemModel(id: 'general-1', type: ProfileMenuItemType.shareApp, title: l10n.profileMenuShareApp, subtitle: l10n.profileShareAppSubtitle),
        ProfileMenuItemModel(id: 'general-2', type: ProfileMenuItemType.aboutApp, title: l10n.profileMenuAbout),
        ProfileMenuItemModel(id: 'general-3', type: ProfileMenuItemType.helpCenter, title: l10n.profileMenuHelp, subtitle: '---'),
        ProfileMenuItemModel(id: 'general-4', type: ProfileMenuItemType.privacyPolicy, title: l10n.profileMenuPrivacy),
      ],
      languageOptions: [
        ProfileLanguageOptionModel(code: 'uz', title: l10n.languageUzbek, flagEmoji: '🇺🇿'),
        ProfileLanguageOptionModel(code: 'ru', title: l10n.languageRussian, flagEmoji: '🇷🇺'),
        ProfileLanguageOptionModel(code: 'en', title: l10n.languageEnglish, flagEmoji: '🇬🇧'),
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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: profileBlocListener,
        builder: (context, state) {
          final isInitialLoading = (state.status == ProfileStatus.loading || state.status == ProfileStatus.initial) && state.overview == null;

          if (state.requiresRegistration) {
            return const SizedBox.shrink();
          }
          if (state.overview == null && !isInitialLoading) {
            return AppFailureState(message: l10n.profileOverviewLoadError, onRetry: () => retry(context));
          }
          final overview = state.overview ?? _skeletonOverview(context);

          final bottomInset = MediaQuery.paddingOf(context).bottom;
          return ListenableBuilder(
            listenable: getIt<ProfileAvatarRefreshNotifier>(),
            builder: (context, _) {
              final avatarGen = getIt<ProfileAvatarRefreshNotifier>().generation;
              return SafeArea(
                bottom: false,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _ProfilePinnedHeaderDelegate(
                        overview: overview,
                        enabledSkeleton: isInitialLoading,
                        avatarImageGeneration: avatarGen,
                        onBadgeTap: isInitialLoading ? null : () => onProfileBadgePressed(context, overview: overview),
                        expandedHeader: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: buildProfileHeader(context, overview: overview, avatarImageGeneration: avatarGen, loading: isInitialLoading),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: buildProfileStats(context, overview: overview, loading: isInitialLoading),
                                  ),
                                  const SizedBox(height: 18),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: buildAchievementsSection(context, overview: overview),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: buildSettingsSection(context, overview: overview),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: buildGeneralSection(context, overview: overview),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: buildDeleteAccountSection(context)),
                          const SizedBox(height: 10),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: buildLogoutSection(context)),
                          const SizedBox(height: 16),
                          Center(
                            child: ProfileAppVersionText(style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey)),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfilePinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfilePinnedHeaderDelegate({required this.overview, required this.enabledSkeleton, required this.avatarImageGeneration, required this.onBadgeTap, required this.expandedHeader});

  final ProfileOverviewModel overview;
  final bool enabledSkeleton;
  final int avatarImageGeneration;
  final VoidCallback? onBadgeTap;
  final Widget expandedHeader;

  static const double _maxHeight = 170;
  static const double _minHeight = 85;

  @override
  double get minExtent => _minHeight;

  @override
  double get maxExtent => _maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final expandedFactor = (1 - progress).clamp(0.0, 1.0);

    return ColoredBox(
      color: Color.lerp(context.theme.scaffoldBackgroundColor, context.theme.scaffoldBackgroundColor, progress) ?? context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Stack(
          children: [
            Opacity(
              opacity: 1 - progress,
              child: IgnorePointer(
                ignoring: progress > 0.6,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: expandedFactor,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Skeletonizer.zone(enabled: enabledSkeleton, child: expandedHeader),
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: progress,
              child: IgnorePointer(
                ignoring: progress < 0.4,
                child: Align(
                  alignment: Alignment.center,
                  child: _CompactPinnedHeader(overview: overview, enabledSkeleton: enabledSkeleton, avatarImageGeneration: avatarImageGeneration, onBadgeTap: onBadgeTap),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ProfilePinnedHeaderDelegate oldDelegate) {
    return oldDelegate.overview != overview ||
        oldDelegate.enabledSkeleton != enabledSkeleton ||
        oldDelegate.avatarImageGeneration != avatarImageGeneration ||
        oldDelegate.onBadgeTap != onBadgeTap ||
        oldDelegate.expandedHeader != expandedHeader;
  }
}

class _CompactPinnedHeader extends StatelessWidget {
  const _CompactPinnedHeader({required this.overview, required this.enabledSkeleton, required this.avatarImageGeneration, this.onBadgeTap});

  final ProfileOverviewModel overview;
  final bool enabledSkeleton;
  final int avatarImageGeneration;
  final VoidCallback? onBadgeTap;

  @override
  Widget build(BuildContext context) {
    if (enabledSkeleton) {
      return Skeletonizer.zone(
        enabled: true,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusXl,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.appColors.primary, width: 2),
                ),
                child: Center(child: Bone.circle(size: 40)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Bone.text(words: 3, fontSize: 14), const SizedBox(height: 4), Bone.text(words: 2, fontSize: 12)],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final rawAvatar = overview.user.avatarUrl.trim();
    var resolvedAvatar = rawAvatar.isEmpty ? '' : Apis.resolveUrl(rawAvatar);
    if (resolvedAvatar.isNotEmpty && avatarImageGeneration != 0) {
      resolvedAvatar = resolvedAvatar.contains('?') ? '$resolvedAvatar&v=$avatarImageGeneration' : '$resolvedAvatar?v=$avatarImageGeneration';
    }
    final hasAvatar = resolvedAvatar.isNotEmpty;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Row(
        children: [
          AppTappableProfileAvatar(
            size: 48,
            borderWidth: 2,
            heroId: 'profile_pinned_compact_${overview.user.userId}',
            resolvedNetworkUrl: hasAvatar ? resolvedAvatar : '',
            placeholder: Icon(LucideIcons.user, color: context.appColors.grey, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileFullNameWithBadge(
                  user: overview.user,
                  nameStyle: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.text),
                  badgeSize: 24,
                  badgeGap: 6,
                  maxLines: 1,
                  fallbackTextAlign: TextAlign.start,
                  rowMainAxisAlignment: MainAxisAlignment.start,
                  onBadgeTap: onBadgeTap,
                ),
                const SizedBox(height: 2),
                Text(
                  profilePhoneSubtitleLine(overview.user.phoneNumber),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
