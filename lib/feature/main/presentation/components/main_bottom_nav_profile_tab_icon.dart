import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/services/profile_avatar_refresh_notifier.dart';

/// Bottom nav uchun avatar URL ni dedupe qiladi.
///
/// Muammo: `MainBottomNavProfileTabIcon` rebuild bo'lganda `FutureBuilder` yangi future
/// yaratib yuboradi va `GET /user/me` ko'p marta ketadi (tab switch, animatsiya, setState).
class _MainBottomNavAvatarUrlCache {
  Future<String?>? _inFlight;
  int? _inFlightGeneration;

  String? _cachedUrl;
  DateTime? _cachedAt;
  int? _cachedGeneration;

  static const Duration _ttl = Duration(minutes: 5);

  Future<String?> load({required int generation}) {
    final now = DateTime.now();

    final cachedAt = _cachedAt;
    final cachedGen = _cachedGeneration;
    if (cachedAt != null && cachedGen == generation && now.difference(cachedAt) < _ttl) {
      return Future<String?>.value(_cachedUrl);
    }

    final inFlight = _inFlight;
    if (inFlight != null && _inFlightGeneration == generation) {
      return inFlight;
    }

    final future = _load(generation: generation);
    _inFlight = future;
    _inFlightGeneration = generation;
    return future.whenComplete(() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
        _inFlightGeneration = null;
      }
    });
  }

  Future<String?> _load({required int generation}) async {
    try {
      final overview = await getIt<ProfileRepository>().getProfileOverview();
      final avatarUrl = overview.user.avatarUrl.trim();
      final resolved = avatarUrl.isEmpty ? null : Apis.resolveUrl(avatarUrl);

      _cachedUrl = resolved;
      _cachedAt = DateTime.now();
      _cachedGeneration = generation;
      return resolved;
    } catch (_) {
      // Error bo'lsa ham spam bo'lmasin: qisqa TTL bilan null keshlaymiz.
      _cachedUrl = null;
      _cachedAt = DateTime.now();
      _cachedGeneration = generation;
      return null;
    }
  }
}

final _MainBottomNavAvatarUrlCache _mainBottomNavAvatarUrlCache = _MainBottomNavAvatarUrlCache();

/// Pastki navigatsiyadagi profil tabi: tarmoq avatar yoki [MainBottomNavKitIcons.user].
class MainBottomNavProfileTabIcon extends StatelessWidget {
  const MainBottomNavProfileTabIcon({super.key, required this.isGuestMode, required this.selected, required this.selectedColor, required this.unselectedColor, this.iconSize = 24});

  final bool isGuestMode;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;

  /// Pastki bar [SecondLiquidBottomNav] / [LiquidBottomNav] `iconSize` bilan mos.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (isGuestMode) {
      return MainBottomNavKitIcons.user(selected ? selectedColor : unselectedColor, iconSize, selected);
    }

    final appColors = context.appColors;
    return ListenableBuilder(
      listenable: getIt<ProfileAvatarRefreshNotifier>(),
      builder: (context, _) {
        final avatarGen = getIt<ProfileAvatarRefreshNotifier>().generation;
        return FutureBuilder<String?>(
          key: ValueKey<int>(avatarGen),
          future: _mainBottomNavAvatarUrlCache.load(generation: avatarGen),
          builder: (context, snapshot) {
            final url = snapshot.data;
            final hasUrl = url != null && url.isNotEmpty;
            if (!hasUrl) {
              return MainBottomNavKitIcons.user(selected ? selectedColor : unselectedColor, iconSize, selected);
            }

            final borderColor = selected ? appColors.primary : unselectedColor;
            return Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
              ),
              child: ClipOval(
                child: AppCachedNetworkImage(
                  imageUrl: url,
                  cacheKey: '$url#$avatarGen',
                  fit: BoxFit.cover,
                  width: iconSize,
                  height: iconSize,
                  fallback: AppNetworkImageFallbackAvatar(iconSize: iconSize * 0.7, iconColor: borderColor, placeholderShowsIcon: false, errorShowsBackground: false),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
