import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_pick_result.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_picker.dart';

/// [permission_handler](https://pub.dev/packages/permission_handler) bilan oldindan ruxsat,
/// keyin [adaptive_media_picker](https://pub.dev/packages/adaptive_media_picker).
class ProfileAdaptivePhotoPicker implements ProfilePhotoPicker {
  ProfileAdaptivePhotoPicker({AdaptiveMediaPicker? picker})
      : _picker = picker ?? AdaptiveMediaPicker();

  final AdaptiveMediaPicker _picker;

  @override
  Future<ProfilePhotoPickResult> pickProfileAvatarFromGallery(
    BuildContext context,
  ) async {
    final themeBrightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final preflight = await _precheckPhotosLibraryPermission();
    if (preflight != null) {
      return preflight;
    }
    if (!context.mounted) {
      return const ProfilePhotoPickCanceled();
    }

    final result = await _picker.pickImage(
      context: context,
      options: PickOptions(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2048,
        wantToCrop: false,
        themeBrightness: themeBrightness,
        primaryColor: primaryColor,
      ),
    );

    final path = result.item?.path;
    if (path != null && path.isNotEmpty) {
      return ProfilePhotoPickSuccess(path);
    }

    if (result.error == PickError.canceled ||
        result.error == PickError.cropCanceled) {
      return const ProfilePhotoPickCanceled();
    }

    if (result.permissionResolution.permanentlyDenied) {
      return const ProfilePhotoPickPermissionDenied();
    }

    if (result.error == PickError.io || result.error == PickError.unknown) {
      return ProfilePhotoPickFailure(debugMessage: result.error?.name);
    }

    return const ProfilePhotoPickCanceled();
  }

  /// Web: brauzer o‘zi so‘raydi. Mobile: [Permission.photos] ([permission_handler](https://pub.dev/packages/permission_handler)).
  Future<ProfilePhotoPickResult?> _precheckPhotosLibraryPermission() async {
    if (kIsWeb) {
      return null;
    }

    var status = await Permission.photos.status;
    if (status.isGranted || status.isLimited) {
      return null;
    }

    if (status.isRestricted) {
      return const ProfilePhotoPickFailure(debugMessage: 'restricted');
    }

    if (status.isPermanentlyDenied) {
      return const ProfilePhotoPickPermissionDenied();
    }

    status = await Permission.photos.request();
    if (status.isGranted || status.isLimited) {
      return null;
    }
    if (status.isPermanentlyDenied) {
      return const ProfilePhotoPickPermissionDenied();
    }
    if (status.isRestricted) {
      return const ProfilePhotoPickFailure(debugMessage: 'restricted');
    }
    return const ProfilePhotoPickCanceled();
  }
}
