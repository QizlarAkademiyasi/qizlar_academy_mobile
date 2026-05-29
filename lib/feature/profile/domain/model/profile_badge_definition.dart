import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// [assets/profile/profile_badges.json] dagi bitta badge; `id` PATCH `badge` maydoniga yuboriladi.
class ProfileBadgeDefinition extends Equatable {
  const ProfileBadgeDefinition({
    required this.id,
    required this.file,
    this.key,
  });

  final int id;
  /// `packages/qizlar_academy_kit/assets/badges/` ichidagi fayl nomi.
  final String file;
  final String? key;

  String get packageAssetPath => 'packages/qizlar_academy_kit/assets/badges/$file';

  @override
  List<Object?> get props => [id, file, key];
}
