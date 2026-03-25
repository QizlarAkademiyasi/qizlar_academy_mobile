import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';

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
  ];
}

class ProfileUserModel extends Equatable {
  const ProfileUserModel({
    required this.fullName,
    required this.userId,
    required this.avatarUrl,
  });

  final String fullName;
  final String userId;
  final String avatarUrl;

  @override
  List<Object?> get props => [fullName, userId, avatarUrl];
}

class ProfileStatModel extends Equatable {
  const ProfileStatModel({required this.value, required this.label});

  final String value;
  final String label;

  @override
  List<Object?> get props => [value, label];
}
