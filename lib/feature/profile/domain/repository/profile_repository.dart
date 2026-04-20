import 'package:qizlar_academy_mobile/config/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
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

  /// Hisobni serverda butunlay o‘chiradi, so‘ng mahalliy sessiya tozalanadi.
  Future<void> deleteMyAccount();

  /// O'zgargan maydonlar bo'yicha PATCH; o'zgarish bo'lmasa `null`.
  Future<ProfileOverviewModel?> patchMyProfileIfChanged({
    required ProfileUserModel baseline,
    required String firstName,
    required String lastName,
    required String occupation,
    String? uploadedPhotoFilename,
    required int selectedBadgeId,
    RegionModel? selectedRegion,
    DistrictModel? selectedDistrict,
    NeighborhoodModel? selectedNeighborhood,
    RegionModel? baselineRegion,
    DistrictModel? baselineDistrict,
    NeighborhoodModel? baselineNeighborhood,
    DateTime? selectedBirthday,
    EducationType? selectedEducationType,
  });
}
