import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum ProfileMenuItemType {
  certificates,
  myCourses,
  myActivity,
  vacancies,
  profileInfo,
  language,
  shareApp,
  aboutApp,
  helpCenter,
  privacyPolicy,
}

class ProfileMenuItemModel extends Equatable {
  const ProfileMenuItemModel({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.badgeCount,
  });

  final String id;
  final ProfileMenuItemType type;
  final String title;
  final String? subtitle;
  final int? badgeCount;

  @override
  List<Object?> get props => [id, type, title, subtitle, badgeCount];
}
