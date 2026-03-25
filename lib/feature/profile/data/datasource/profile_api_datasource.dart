import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_datasource.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/exception/profile_registration_required_exception.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

class ProfileApiDatasource implements ProfileDatasource {
  const ProfileApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<ProfileOverviewModel> getProfileOverview() async {
    final response = await _dio.get<dynamic>(Apis.userMe);
    final envelope = _asMap(response.data);
    final data = _asMapOrNull(envelope['data']);
    if (data == null || data.isEmpty) {
      throw const ProfileRegistrationRequiredException();
    }
    return _mapOverview(data);
  }

  @override
  Future<ProfileOverviewModel> updateDarkMode({required bool enabled}) async {
    await _dio.patch<dynamic>(
      Apis.userMe,
      data: <String, dynamic>{'dark_mode': enabled},
    );
    return getProfileOverview();
  }

  @override
  Future<ProfileOverviewModel> updateLanguage({required String code}) async {
    await _dio.patch<dynamic>(
      Apis.profileLanguage,
      data: <String, dynamic>{'code': code},
    );
    return getProfileOverview();
  }

  @override
  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  }) async {
    await _dio.patch<dynamic>(
      Apis.userMe,
      data: <String, dynamic>{
        'firstname': firstName,
        'lastname': lastName,
      },
    );
    return getProfileOverview();
  }

  @override
  Future<ProfileOverviewModel> updateNotifications({required bool enabled}) async {
    await _dio.patch<dynamic>(
      Apis.profileNotifications,
      data: <String, dynamic>{'enabled': enabled},
    );
    return getProfileOverview();
  }

  ProfileOverviewModel _mapOverview(Map<String, dynamic> data) {
    final firstName = (data['firstname'] ?? '').toString().trim();
    final lastName = (data['lastname'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();
    final points = _parseInt(data['points']);
    final education = _asMapOrNull(data['educaton']);
    final educationRegion = _asMapOrNull(education?['region']);
    final educationDistrict = _asMapOrNull(education?['district']);
    final educationType = (education?['type'] ?? '').toString();
    final educationOrganization = (education?['organization'] ?? '').toString();
    final educationLocation = [
      (educationRegion?['name'] ?? '').toString(),
      (educationDistrict?['name'] ?? '').toString(),
    ].where((item) => item.trim().isNotEmpty).join(', ');
    final profileInfoSubtitle = [
      if (educationType.isNotEmpty) educationType,
      if (educationOrganization.isNotEmpty) educationOrganization,
      if (educationLocation.isNotEmpty) educationLocation,
    ].join(' • ');

    return ProfileOverviewModel(
      user: ProfileUserModel(
        fullName: fullName,
        userId: (data['id'] ?? '').toString(),
        avatarUrl: (data['photo'] ?? '').toString(),
      ),
      stats: [
        ProfileStatModel(value: '$points', label: 'Ballar'),
      ],
      bankFilters: const [],
      achievements: const <ProfileMenuItemModel>[],
      settings: [
        ProfileMenuItemModel(
          id: 'profile-info',
          type: ProfileMenuItemType.profileInfo,
          title: 'Profil ma\'lumotlari',
          subtitle: profileInfoSubtitle.isEmpty ? null : profileInfoSubtitle,
        ),
        const ProfileMenuItemModel(
          id: 'language',
          type: ProfileMenuItemType.language,
          title: 'Til',
          subtitle: 'O\'zbekcha',
        ),
      ],
      general: const <ProfileMenuItemModel>[
        ProfileMenuItemModel(
          id: 'share',
          type: ProfileMenuItemType.shareApp,
          title: 'Ilovani ulashish',
        ),
        ProfileMenuItemModel(
          id: 'about',
          type: ProfileMenuItemType.aboutApp,
          title: 'Biz haqimizda',
        ),
        ProfileMenuItemModel(
          id: 'help',
          type: ProfileMenuItemType.helpCenter,
          title: 'Yordam markazi',
        ),
        ProfileMenuItemModel(
          id: 'privacy',
          type: ProfileMenuItemType.privacyPolicy,
          title: 'Maxfiylik siyosati',
        ),
      ],
      languageOptions: const [
        ProfileLanguageOptionModel(
          code: 'uz',
          title: 'O\'zbekcha',
          flagEmoji: '🇺🇿',
        ),
        ProfileLanguageOptionModel(
          code: 'ru',
          title: 'Русский',
          flagEmoji: '🇷🇺',
        ),
        ProfileLanguageOptionModel(
          code: 'en',
          title: 'English',
          flagEmoji: '🇬🇧',
        ),
      ],
      selectedLanguageCode: 'uz',
      notificationsEnabled: false,
      darkModeEnabled: false,
      versionName: '',
    );
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic>? _asMapOrNull(dynamic data) {
    final map = _asMap(data);
    return map.isEmpty ? null : map;
  }

  int _parseInt(dynamic value) => int.tryParse('${value ?? 0}') ?? 0;
}
