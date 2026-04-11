import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/profile_badge_catalog_loader.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

class LeaderboardUserDetailsBottomSheet extends StatefulWidget {
  const LeaderboardUserDetailsBottomSheet({super.key, required this.user, required this.courseName});

  final LeaderboardUserModel user;
  final String courseName;

  @override
  State<LeaderboardUserDetailsBottomSheet> createState() => _LeaderboardUserDetailsBottomSheetState();
}

class _LeaderboardUserDetailsBottomSheetState extends State<LeaderboardUserDetailsBottomSheet> {
  late final Future<ProfileUserPublicModel> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<ProfileRepository>().getUserProfileById(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileUserPublicModel>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final isLoading = snapshot.connectionState != ConnectionState.done;
        final hasError = snapshot.hasError && data == null;

        final firstName = (data?.firstname ?? widget.user.firstname).trim();
        final lastName = (data?.lastname ?? widget.user.lastname).trim();
        final fullName = '$firstName $lastName'.trim().isEmpty ? widget.user.fullName : '$firstName $lastName'.trim();
        final badgeId = data?.badge;

        return AppBottomSheetContainer(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AppTappableProfileAvatar(
                    size: 64,
                    borderWidth: 2,
                    heroId: 'leader_sheet_${widget.user.id}',
                    resolvedNetworkUrl: widget.user.avatarUrl,
                    placeholder: ColoredBox(
                      color: context.appColors.stroke,
                      child: Icon(LucideIcons.user, size: 30, color: context.appColors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeletonizer.zone(
                          enabled: isLoading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FullNameWithTrailingBadge(
                                fullName: fullName,
                                badgeId: badgeId,
                                isLoading: isLoading,
                                textStyle: context.textTheme.bodyXLargeBold.copyWith(color: context.appColors.text),
                              ),
                              const SizedBox(height: 2),
                              Text(widget.courseName, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('Ma’lumotlarni yuklashda xatolik.', style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
                ),
              Skeletonizer.zone(
                enabled: isLoading,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(value: data?.enrolledCourseCount, label: 'Kurslar', isLoading: isLoading),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(value: data?.rating, label: 'Bahosi', isLoading: isLoading),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _StatCard(value: data?.certificateCount, label: 'Sertifikatlar', fullWidth: true, isLoading: isLoading),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.isLoading, this.fullWidth = false});

  final int? value;
  final String label;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: context.appColors.onContainer.withValues(alpha: 0.65),
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Column(
        children: [
          if (isLoading) Bone.text(words: 1, fontSize: 20) else Text('${value ?? ''}', style: context.textTheme.heading5.copyWith(color: context.appColors.text)),
          const SizedBox(height: 2),
          Text(label, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
        ],
      ),
    );
  }
}

class _FullNameWithTrailingBadge extends StatelessWidget {
  const _FullNameWithTrailingBadge({required this.fullName, required this.badgeId, required this.isLoading, required this.textStyle});

  final String fullName;
  final int? badgeId;
  final bool isLoading;
  final TextStyle textStyle;

  ProfileBadgeDefinition? _resolveBadge(List<ProfileBadgeDefinition> catalog) {
    if (catalog.isEmpty) return null;
    final id = ProfileBadgeCatalogLoader.coerceSelection(badgeId ?? 0, catalog);
    for (final b in catalog) {
      if (b.id == id) return b;
    }
    return catalog.first;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: Bone.text(words: 2, fontSize: 16)),
          const SizedBox(width: 8),
          Bone.circle(size: 34),
        ],
      );
    }

    return FutureBuilder<List<ProfileBadgeDefinition>>(
      future: ProfileBadgeCatalogLoader.load(),
      builder: (context, snapshot) {
        final catalog = snapshot.data ?? const <ProfileBadgeDefinition>[];
        final badge = _resolveBadge(catalog);

        if (badge == null) {
          return Text(fullName, maxLines: 2, overflow: TextOverflow.ellipsis, style: textStyle);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(fullName, maxLines: 2, overflow: TextOverflow.ellipsis, style: textStyle),
            ),
            const SizedBox(width: 8),
            SizedBox(width: 24, height: 24, child: Lottie.asset(badge.packageAssetPath, fit: BoxFit.contain, repeat: true)),
          ],
        );
      },
    );
  }
}
