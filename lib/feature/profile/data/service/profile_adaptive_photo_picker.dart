import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_pick_result.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_picker.dart';

/// Android'da broad media permission so'ramaydigan system Photo Picker'dan
/// foydalanadi. Android 13+ da [ImagePicker] buni avtomatik qo'llaydi.
class ProfileAdaptivePhotoPicker implements ProfilePhotoPicker {
  ProfileAdaptivePhotoPicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<ProfilePhotoPickResult> pickProfileAvatarFromGallery(
    BuildContext context,
  ) async {
    try {
      final result = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2048,
      );

      final path = result?.path;
      if (path == null) {
        return const ProfilePhotoPickCanceled();
      }
      if (path.isEmpty) {
        return const ProfilePhotoPickFailure(debugMessage: 'empty_path');
      }
      return ProfilePhotoPickSuccess(path);
    } catch (error, stackTrace) {
      AppLogger.e(
        'ProfileAdaptivePhotoPicker: system picker failed',
        error: error,
        stackTrace: stackTrace,
      );
      return ProfilePhotoPickFailure(debugMessage: error.toString());
    }
  }
}
