import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

/// Serverdagi [baseline] bilan solishtirib, `PATCH /user/me` da yuboriladigan o‘zgarish bormi.
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

/// UI va [ProfileRepository.patchMyProfileIfChanged] bir xil qoida bo‘lishi uchun.
bool profileEditHasPendingPatch({
  required ProfileUserModel baseline,
  required String firstName,
  required String lastName,
  String? uploadedPhotoFilename,
  required int selectedBadgeId,
}) {
  if (firstName.trim() != baseline.firstName.trim()) return true;
  if (lastName.trim() != baseline.lastName.trim()) return true;
  if (selectedBadgeId != baseline.badgeId) return true;
  if (profilePhotoWouldPatch(baseline.avatarUrl, uploadedPhotoFilename)) {
    return true;
  }
  return false;
}
