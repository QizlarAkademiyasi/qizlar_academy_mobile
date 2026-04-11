import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/services/profile_avatar_refresh_notifier.dart';

Future<String?> _loadMainBottomNavAvatarUrl() async {
  try {
    final overview = await getIt<ProfileRepository>().getProfileOverview();
    final avatarUrl = overview.user.avatarUrl.trim();
    if (avatarUrl.isEmpty) return null;
    return Apis.resolveUrl(avatarUrl);
  } catch (_) {
    return null;
  }
}

/// Pastki navigatsiyadagi profil tabi: tarmoq avatar yoki [MainBottomNavKitIcons.user].
class MainBottomNavProfileTabIcon extends StatelessWidget {
  const MainBottomNavProfileTabIcon({
    super.key,
    required this.isGuestMode,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final bool isGuestMode;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    if (isGuestMode) {
      return MainBottomNavKitIcons.user(selected ? selectedColor : unselectedColor, _size, selected);
    }

    final appColors = context.appColors;
    return ListenableBuilder(
      listenable: getIt<ProfileAvatarRefreshNotifier>(),
      builder: (context, _) {
        final avatarGen = getIt<ProfileAvatarRefreshNotifier>().generation;
        return FutureBuilder<String?>(
          key: ValueKey<int>(avatarGen),
          future: _loadMainBottomNavAvatarUrl(),
          builder: (context, snapshot) {
            final url = snapshot.data;
            final hasUrl = url != null && url.isNotEmpty;
            if (!hasUrl) {
              return MainBottomNavKitIcons.user(selected ? selectedColor : unselectedColor, _size, selected);
            }

            final borderColor = selected ? appColors.primary : unselectedColor;
            return Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
              ),
              child: ClipOval(
                child: AppCachedNetworkImage(
                  imageUrl: url,
                  cacheKey: '$url#$avatarGen',
                  fit: BoxFit.cover,
                  width: _size,
                  height: _size,
                  fallback: AppNetworkImageFallbackAvatar(
                    iconSize: _size * 0.7,
                    iconColor: borderColor,
                    placeholderShowsIcon: false,
                    errorShowsBackground: false,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
