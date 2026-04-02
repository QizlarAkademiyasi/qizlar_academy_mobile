import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';

abstract interface class ProfileRepository {
  Future<ProfileOverviewModel> getProfileOverview();

  Future<ProfileUserPublicModel> getUserProfileById(String id);

  Future<ProfileOverviewModel> updateNotifications({required bool enabled});

  Future<ProfileOverviewModel> updateDarkMode({required bool enabled});

  Future<ProfileOverviewModel> updateLanguage({required String code});

  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  });

  Future<String> uploadProfilePhoto(String localFilePath);

  /// O‘zgargan maydonlar bo‘yicha PATCH; o‘zgarish bo‘lmasa `null`.
  Future<ProfileOverviewModel?> patchMyProfileIfChanged({
    required ProfileUserModel baseline,
    required String firstName,
    required String lastName,
    String? uploadedPhotoFilename,
    required int selectedBadgeId,
  });
}
