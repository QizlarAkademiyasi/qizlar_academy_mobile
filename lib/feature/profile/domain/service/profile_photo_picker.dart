import 'package:flutter/widgets.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_pick_result.dart';

/// Profil tahriri uchun rasm tanlash (gallery / limited access / ruxsatlar).
///
/// Implementatsiya data qatlamida; UI faqat [pickProfileAvatarFromGallery] chaqiradi.
abstract class ProfilePhotoPicker {
  Future<ProfilePhotoPickResult> pickProfileAvatarFromGallery(BuildContext context);
}
