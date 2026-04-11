import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';

/// Profil «HISOB» bo‘limidagi uchta band (API bo‘sh qaytarsa ham shu tartibda ko‘rsatiladi).
const List<ProfileMenuItemModel> kDefaultProfileAchievementItems = <ProfileMenuItemModel>[
  ProfileMenuItemModel(
    id: 'achievements-certificates',
    type: ProfileMenuItemType.certificates,
    title: '',
  ),
  ProfileMenuItemModel(
    id: 'achievements-courses',
    type: ProfileMenuItemType.myCourses,
    title: '',
  ),
  ProfileMenuItemModel(
    id: 'achievements-activity',
    type: ProfileMenuItemType.myActivity,
    title: '',
  ),
  ProfileMenuItemModel(
    id: 'achievements-vacancies',
    type: ProfileMenuItemType.vacancies,
    title: '',
  ),
];

class ProfileOverviewModel extends Equatable {
  const ProfileOverviewModel({
    required this.user,
    required this.stats,
    required this.bankFilters,
    required this.achievements,
    required this.settings,
    required this.general,
    required this.languageOptions,
    required this.selectedLanguageCode,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.versionName,
    this.certificatesCount,
    this.activeCoursesCount,
    this.rating,
  });

  final ProfileUserModel user;
  final List<ProfileStatModel> stats;
  final List<Widget> bankFilters;
  final List<ProfileMenuItemModel> achievements;
  final List<ProfileMenuItemModel> settings;
  final List<ProfileMenuItemModel> general;
  final List<ProfileLanguageOptionModel> languageOptions;
  final String selectedLanguageCode;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String versionName;
  /// `/user/me` yoki nested `stats` dan; subtitl va sertifikat badge uchun.
  final int? certificatesCount;
  final int? activeCoursesCount;
  /// Reyting (alohida maydon bo‘lmasa, API `points` bilan to‘ldiriladi).
  final int? rating;

  ProfileOverviewModel copyWith({
    ProfileUserModel? user,
    List<ProfileStatModel>? stats,
    List<Widget>? bankFilters,
    List<ProfileMenuItemModel>? achievements,
    List<ProfileMenuItemModel>? settings,
    List<ProfileMenuItemModel>? general,
    List<ProfileLanguageOptionModel>? languageOptions,
    String? selectedLanguageCode,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? versionName,
    int? certificatesCount,
    int? activeCoursesCount,
    int? rating,
  }) {
    return ProfileOverviewModel(
      user: user ?? this.user,
      stats: stats ?? this.stats,
      bankFilters: bankFilters ?? this.bankFilters,
      achievements: achievements ?? this.achievements,
      settings: settings ?? this.settings,
      general: general ?? this.general,
      languageOptions: languageOptions ?? this.languageOptions,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      versionName: versionName ?? this.versionName,
      certificatesCount: certificatesCount ?? this.certificatesCount,
      activeCoursesCount: activeCoursesCount ?? this.activeCoursesCount,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
    user,
    stats,
    bankFilters,
    achievements,
    settings,
    general,
    languageOptions,
    selectedLanguageCode,
    notificationsEnabled,
    darkModeEnabled,
    versionName,
    certificatesCount,
    activeCoursesCount,
    rating,
  ];
}

class ProfileUserModel extends Equatable {
  const ProfileUserModel({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.userId,
    required this.phoneNumber,
    required this.avatarUrl,
    this.badgeId = 0,
  });

  final String firstName;
  final String lastName;
  final String fullName;
  final String userId;
  /// Backenddan keladigan telefon (masalan +998… yoki raqamlar qatori).
  final String phoneNumber;
  final String avatarUrl;
  /// Profil badge indeksi (`PATCH` da `badge`); [assets/profile/profile_badges.json] dagi `id`.
  final int badgeId;

  @override
  List<Object?> get props => [firstName, lastName, fullName, userId, phoneNumber, avatarUrl, badgeId];
}

class ProfileStatModel extends Equatable {
  const ProfileStatModel({required this.value, required this.label});

  final String value;
  final String label;

  @override
  List<Object?> get props => [value, label];
}
