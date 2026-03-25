import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/profile_screen_mixin.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..add(const ProfileStarted()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with ProfileScreenMixin<_ProfileView> {
  static const ProfileOverviewModel _skeletonOverview = ProfileOverviewModel(
    user: ProfileUserModel(
      fullName: '--- -------',
      userId: '------',
      avatarUrl: '',
    ),
    stats: [
      ProfileStatModel(value: '0', label: 'Kurslar'),
      ProfileStatModel(value: '0', label: 'Sertifikatlar'),
      ProfileStatModel(value: '0', label: 'Reyting'),
    ],
    bankFilters: [],
    achievements: [
      ProfileMenuItemModel(
        id: 'achievements-1',
        type: ProfileMenuItemType.certificates,
        title: 'Sertifikatlarim',
        subtitle: '---',
        badgeCount: 0,
      ),
      ProfileMenuItemModel(
        id: 'achievements-2',
        type: ProfileMenuItemType.myCourses,
        title: 'Mening kurslarim',
        subtitle: '---',
      ),
      ProfileMenuItemModel(
        id: 'achievements-3',
        type: ProfileMenuItemType.myActivity,
        title: 'Mening faolligim',
      ),
    ],
    settings: [
      ProfileMenuItemModel(
        id: 'settings-1',
        type: ProfileMenuItemType.profileInfo,
        title: 'Profil ma\'lumotlari',
      ),
      ProfileMenuItemModel(
        id: 'settings-2',
        type: ProfileMenuItemType.language,
        title: 'Til',
        subtitle: '---',
      ),
    ],
    general: [
      ProfileMenuItemModel(
        id: 'general-1',
        type: ProfileMenuItemType.shareApp,
        title: 'Ilovani ulashish',
        subtitle: '---',
      ),
      ProfileMenuItemModel(
        id: 'general-2',
        type: ProfileMenuItemType.aboutApp,
        title: 'Biz haqimizda',
      ),
      ProfileMenuItemModel(
        id: 'general-3',
        type: ProfileMenuItemType.helpCenter,
        title: 'Yordam markazi',
        subtitle: '---',
      ),
      ProfileMenuItemModel(
        id: 'general-4',
        type: ProfileMenuItemType.privacyPolicy,
        title: 'Maxfiylik siyosati',
      ),
    ],
    languageOptions: [
      ProfileLanguageOptionModel(
        code: 'uz',
        title: 'O\'zbekcha',
        flagEmoji: '🇺🇿',
      ),
      ProfileLanguageOptionModel(
        code: 'ru',
        title: 'Русский',
        flagEmoji: '🇷🇺',
      ),
      ProfileLanguageOptionModel(
        code: 'en',
        title: 'English',
        flagEmoji: '🇬🇧',
      ),
    ],
    selectedLanguageCode: 'uz',
    notificationsEnabled: false,
    darkModeEnabled: false,
    versionName: '...',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: profileBlocListener,
        builder: (context, state) {
          final isInitialLoading =
              (state.status == ProfileStatus.loading ||
                  state.status == ProfileStatus.initial) &&
              state.overview == null;

          if (state.overview == null && !isInitialLoading) {
            return TgsFailureContent(
              message: state.message ?? 'Profil ma\'lumotlari mavjud emas.',
              onRetry: () => retry(context),
            );
          }
          final overview = state.overview ?? _skeletonOverview;

          final bottomInset = MediaQuery.paddingOf(context).bottom;
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
                    expandedHeader: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: buildProfileHeader(context, overview: overview),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 80 + bottomInset),
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
                                ),
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: buildAchievementsSection(
                                  context,
                                  overview: overview,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: buildSettingsSection(
                                  context,
                                  overview: overview,
                                ),
                              ),
                              const SizedBox(height: 12),
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
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: buildLogoutSection(context),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Versiya ${overview.versionName}',
                          style: context.textTheme.bodySmallRegular.copyWith(
                            color: context.appColors.secondaryGrey,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfilePinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfilePinnedHeaderDelegate({
    required this.overview,
    required this.enabledSkeleton,
    required this.expandedHeader,
  });

  final ProfileOverviewModel overview;
  final bool enabledSkeleton;
  final Widget expandedHeader;

  static const double _maxHeight = 170;
  static const double _minHeight = 85;

  @override
  double get minExtent => _minHeight;

  @override
  double get maxExtent => _maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final expandedFactor = (1 - progress).clamp(0.0, 1.0);

    return ColoredBox(
      color:
          Color.lerp(
            context.theme.scaffoldBackgroundColor,
            context.theme.scaffoldBackgroundColor,
            progress,
          ) ??
          context.theme.scaffoldBackgroundColor,
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
                      child: Skeletonizer.zone(
                        enabled: enabledSkeleton,
                        child: expandedHeader,
                      ),
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
                  child: _CompactPinnedHeader(
                    overview: overview,
                    enabledSkeleton: enabledSkeleton,
                  ),
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
        oldDelegate.expandedHeader != expandedHeader;
  }
}

class _CompactPinnedHeader extends StatelessWidget {
  const _CompactPinnedHeader({
    required this.overview,
    required this.enabledSkeleton,
  });

  final ProfileOverviewModel overview;
  final bool enabledSkeleton;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      enabled: enabledSkeleton,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(overview.user.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: context.appColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overview.user.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMediumSemibold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'id: ${overview.user.userId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyXSmallRegular.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
