import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Profil avatarini tanlash natijasi (presentation / bloc uchun paketdan mustaqil).
sealed class ProfilePhotoPickResult extends Equatable {
  const ProfilePhotoPickResult();

  @override
  List<Object?> get props => [];
}

final class ProfilePhotoPickSuccess extends ProfilePhotoPickResult {
  const ProfilePhotoPickSuccess(this.localFilePath);

  final String localFilePath;

  @override
  List<Object?> get props => [localFilePath];
}

final class ProfilePhotoPickCanceled extends ProfilePhotoPickResult {
  const ProfilePhotoPickCanceled();
}

final class ProfilePhotoPickPermissionDenied extends ProfilePhotoPickResult {
  const ProfilePhotoPickPermissionDenied();
}

final class ProfilePhotoPickFailure extends ProfilePhotoPickResult {
  const ProfilePhotoPickFailure({this.debugMessage});

  final String? debugMessage;

  @override
  List<Object?> get props => [debugMessage];
}
