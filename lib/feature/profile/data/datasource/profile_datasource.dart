import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';

abstract interface class ProfileDatasource {
  Future<ProfileOverviewModel> getProfileOverview();

  Future<ProfileUserPublicModel> getUserProfileById(String id);

  Future<ProfileOverviewModel> updateNotifications({required bool enabled});

  Future<ProfileOverviewModel> updateDarkMode({required bool enabled});

  Future<ProfileOverviewModel> updateLanguage({required String code});

  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  });

  /// Multipart yuklash; javobdan fayl nomi (`data`) qaytariladi.
  Future<String> uploadProfilePhoto(String localFilePath);

  /// PATCH `/user/me` — faqat [body] ichidagi kalitlar yuboriladi.
  Future<void> patchUserMe(Map<String, dynamic> body);

  /// Hisobni serverda butunlay o‘chirish (`DELETE /api/v1/user/me`).
  Future<void> deleteMyAccount();
}
