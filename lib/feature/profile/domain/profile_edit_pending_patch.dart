import 'package:qizlar_academy_mobile/config/constants/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

/// Serverdagi [baseline] bilan solishtirib, `PATCH /user/me` da yuboriladigan o'zgarish bormi.
bool profilePhotoWouldPatch(String baselineAvatar, String? uploadedFilename) {
  final u = uploadedFilename?.trim() ?? '';
  if (u.isEmpty) return false;
  final base = baselineAvatar.trim();
  if (base.isEmpty) return true;
  if (base == u) return false;
  final baseFile = base.split('/').last.split('?').first;
  final uFile = u.split('/').last.split('?').first;
  return baseFile != uFile;
}

/// UI va [ProfileRepository.patchMyProfileIfChanged] bir xil qoida bo'lishi uchun.
bool profileEditHasPendingPatch({
  required ProfileUserModel baseline,
  required String firstName,
  required String lastName,
  required String occupation,
  String? uploadedPhotoFilename,
  required int selectedBadgeId,
  RegionModel? selectedRegion,
  DistrictModel? selectedDistrict,
  NeighborhoodModel? selectedNeighborhood,
  DateTime? selectedBirthday,
  EducationType? selectedEducationType,
  RegionModel? baselineRegion,
  DistrictModel? baselineDistrict,
  NeighborhoodModel? baselineNeighborhood,
}) {
  if (firstName.trim() != baseline.firstName.trim()) return true;
  if (lastName.trim() != baseline.lastName.trim()) return true;
  if (occupation.trim() != baseline.occupation.trim()) return true;
  if (selectedBadgeId != baseline.badgeId) return true;
  if (profilePhotoWouldPatch(baseline.avatarUrl, uploadedPhotoFilename)) return true;
  if (selectedRegion?.id != baselineRegion?.id) return true;
  if (selectedDistrict?.id != baselineDistrict?.id) return true;
  if (selectedNeighborhood?.id != baselineNeighborhood?.id) return true;
  if (selectedBirthday != null && selectedBirthday != baseline.birthday) return true;
  if (selectedEducationType != null && selectedEducationType != baseline.educationType) return true;
  return false;
}
