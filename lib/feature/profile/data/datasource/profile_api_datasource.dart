import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_datasource.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/exception/profile_registration_required_exception.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_menu_item_model.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';

class ProfileApiDatasource implements ProfileDatasource {
  const ProfileApiDatasource(this._dio, this._prefs);

  final Dio _dio;
  final SharedPreferences _prefs;

  @override
  Future<ProfileOverviewModel> getProfileOverview() async {
    final response = await _dio.get<dynamic>(UserApis.userMe);
    final envelope = _asMap(response.data);
    final data = _asMapOrNull(envelope['data']);
    if (data == null || data.isEmpty) {
      throw const ProfileRegistrationRequiredException();
    }
    return _mapOverview(data);
  }

  @override
  Future<ProfileUserPublicModel> getUserProfileById(String id) async {
    final response = await _dio.get<dynamic>(UserApis.userProfileById(id));
    final envelope = _asMap(response.data);
    final data = _asMapOrNull(envelope['data']);
    if (data == null || data.isEmpty) {
      throw const FormatException('Unexpected user profile payload');
    }
    return ProfileUserPublicModel(
      id: (data['id'] ?? '').toString(),
      firstname: (data['firstname'] ?? '').toString(),
      lastname: (data['lastname'] ?? '').toString(),
      rating: _parseInt(data['rating']),
      certificateCount: _parseInt(data['certificateCount']),
      enrolledCourseCount: _parseInt(data['enrolledCourseCount']),
      badge: _parseBadgeId(data['badge']),
    );
  }

  @override
  Future<ProfileOverviewModel> updateDarkMode({required bool enabled}) async {
    await _dio.patch<dynamic>(
      UserApis.userMe,
      data: <String, dynamic>{'dark_mode': enabled},
    );
    return getProfileOverview();
  }

  @override
  Future<ProfileOverviewModel> updateLanguage({required String code}) async {
    await _dio.patch<dynamic>(
      UserApis.profileLanguage,
      data: <String, dynamic>{'code': code},
    );
    return getProfileOverview();
  }

  @override
  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  }) async {
    await patchUserMe(<String, dynamic>{
      'firstname': firstName.trim(),
      'lastname': lastName.trim(),
    });
    return getProfileOverview();
  }

  @override
  Future<void> patchUserMe(Map<String, dynamic> body) async {
    if (body.isEmpty) return;
    await _dio.patch<dynamic>(UserApis.userMe, data: body);
  }

  @override
  Future<void> deleteMyAccount() async {
    await _dio.delete<dynamic>(UserApis.userMe);
  }

  @override
  Future<String> uploadProfilePhoto(String localFilePath) async {
    final segments = localFilePath.replaceAll(r'\', '/').split('/');
    final filename = segments.isNotEmpty ? segments.last : 'photo.jpg';
    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(localFilePath, filename: filename),
    });
    final response = await _dio.post<dynamic>(
      UserApis.fileUpload,
      data: formData,
    );
    return _parseUploadedFilename(response.data);
  }

  String _parseUploadedFilename(dynamic raw) {
    final root = _asMap(raw);
    final dataField = root['data'];
    if (dataField is String && dataField.trim().isNotEmpty) {
      return dataField.trim();
    }
    final nested = _asMapOrNull(dataField);
    if (nested != null) {
      final inner = nested['data'];
      if (inner is String && inner.trim().isNotEmpty) {
        return inner.trim();
      }
    }
    throw FormatException('Unexpected file upload payload', raw);
  }

  @override
  Future<ProfileOverviewModel> updateNotifications({
    required bool enabled,
  }) async {
    final fromPrefs = _prefs.getString(StorageKey.fcmToken.name);
    final token = (fromPrefs != null && fromPrefs.isNotEmpty)
        ? fromPrefs
        : await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      throw StateError('FCM token unavailable');
    }
    if (enabled) {
      await _dio.post<dynamic>(
        UserApis.notificationSubscribe,
        data: <String, dynamic>{'token': token},
      );
    } else {
      await _dio.delete<dynamic>(
        UserApis.notificationUnsubscribe,
        data: <String, dynamic>{'token': token},
      );
    }
    final overview = await getProfileOverview();
    return overview.copyWith(notificationsEnabled: enabled);
  }

  Map<String, dynamic>? _educationPayload(Map<String, dynamic> data) {
    final direct = _asMapOrNull(data['education']);
    if (direct != null) return direct;
    return _asMapOrNull(data['educaton']);
  }

  ProfileOverviewModel _mapOverview(Map<String, dynamic> data) {
    final firstName = (data['firstname'] ?? '').toString().trim();
    final lastName = (data['lastname'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();
    final points = _parseInt(data['points']);
    final occupation = (data['occupation'] ?? '').toString().trim();
    final education = _educationPayload(data);
    final educationRegion = _asMapOrNull(education?['region']);
    final educationDistrict = _asMapOrNull(education?['district']);
    final educationTypeRaw = (education?['type'] ?? '').toString().trim();
    final educationTypeLabel = EducationType.tryParseFromApi(educationTypeRaw)?.label ?? educationTypeRaw;
    final educationOrganization = (education?['organization'] ?? '').toString();
    final educationLocation = [
      (educationRegion?['name'] ?? '').toString(),
      (educationDistrict?['name'] ?? '').toString(),
    ].where((item) => item.trim().isNotEmpty).join(', ');
    final profileInfoSubtitle = [
      if (occupation.isNotEmpty) occupation,
      if (educationTypeLabel.isNotEmpty) educationTypeLabel,
      if (educationOrganization.isNotEmpty) educationOrganization,
      if (educationLocation.isNotEmpty) educationLocation,
    ].join(' • ');

    final phoneRaw =
        (data['phone'] ?? data['phone_number'] ?? data['mobile'] ?? '')
            .toString()
            .trim();

    final nestedStats =
        _asMapOrNull(data['stats']) ??
        _asMapOrNull(data['statistics']) ??
        _asMapOrNull(data['summary']);
    final certificatesCount =
        _readNonNegativeInt(data, const [
          'certificateCount',
          'certificates_count',
          'certificate_count',
          'total_certificates',
          'certificates_total',
        ]) ??
        (nestedStats != null
            ? _readNonNegativeInt(nestedStats, const [
                'certificates_count',
                'certificates',
                'certificate_count',
                'total_certificates',
              ])
            : null);
    final activeCoursesCount =
        _readNonNegativeInt(data, const [
          'enrolledCourseCount',
          'active_courses_count',
          'active_courses',
          'courses_active_count',
          'enrolled_courses_count',
        ]) ??
        (nestedStats != null
            ? _readNonNegativeInt(nestedStats, const [
                'active_courses',
                'active_courses_count',
                'courses_count',
                'enrolled_courses',
                'total_courses',
              ])
            : null);
    final ratingRaw =
        _readNonNegativeInt(data, const [
          'rating',
          'rating_value',
          'rank',
          'leaderboard_rank',
          'user_rating',
        ]) ??
        (nestedStats != null
            ? _readNonNegativeInt(nestedStats, const ['rating', 'rank'])
            : null);
    final rating = ratingRaw ?? (points != 0 ? points : null);

    final address = _asMapOrNull(data['address']);

    // regionId: address.region.id yoki address.regionId yoki data.regionId
    final addressRegion = _asMapOrNull(address?['region']);
    final parsedRegionId = _firstPositiveInt([
      addressRegion?['id'],
      addressRegion?['kod'],
      address?['regionId'],
      address?['region_id'],
      data['regionId'],
      data['region_id'],
    ]);
    final parsedRegionName = _addressFieldLabel(address?['region']);

    final addressDistrict = _asMapOrNull(address?['district']);
    final parsedDistrictId = _firstPositiveInt([
      addressDistrict?['id'],
      addressDistrict?['kod'],
      address?['districtId'],
      address?['district_id'],
      data['districtId'],
      data['district_id'],
    ]);
    final parsedDistrictName = _addressFieldLabel(address?['district']);

    final addressNeighborhood = _asMapOrNull(address?['neighborhood']);
    final parsedNeighborhoodId = _firstPositiveInt([
      addressNeighborhood?['id'],
      addressNeighborhood?['kod'],
      address?['neighborhoodId'],
      address?['neighborhood_id'],
      data['neighborhoodId'],
      data['neighborhood_id'],
    ]);
    final parsedNeighborhoodName = _addressFieldLabel(address?['neighborhood']);

    // Tug'ilgan sana
    final birthdayRaw = (data['birthday'] ?? '').toString().trim();
    final birthday = birthdayRaw.isNotEmpty ? DateTime.tryParse(birthdayRaw) : null;

    // Ta'lim turi
    final educationTypeParsed = EducationType.tryParseFromApi(educationTypeRaw);

    return ProfileOverviewModel(
      user: ProfileUserModel(
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
        userId: (data['id'] ?? '').toString(),
        phoneNumber: phoneRaw,
        avatarUrl: (data['photo'] ?? '').toString(),
        occupation: occupation,
        badgeId: _parseBadgeId(data['badge']),
        birthday: birthday,
        regionId: parsedRegionId,
        regionName: parsedRegionName,
        districtId: parsedDistrictId,
        districtName: parsedDistrictName,
        neighborhoodId: parsedNeighborhoodId,
        neighborhoodName: parsedNeighborhoodName,
        educationType: educationTypeParsed,
      ),
      stats: const [],
      bankFilters: const [],
      achievements: kDefaultProfileAchievementItems,
      certificatesCount: certificatesCount,
      activeCoursesCount: activeCoursesCount,
      rating: rating,
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
      notificationsEnabled: _parseNotificationsEnabled(data),
      darkModeEnabled: _parseDarkModeEnabled(data),
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

  /// `address.region` / `district` / `neighborhood` — `{ "name": "..." }` yoki to'g'ridan-to'g'ri qator.
  String _addressFieldLabel(dynamic value) {
    final map = _asMapOrNull(value);
    if (map != null) {
      for (final key in ['name', 'title', 'label']) {
        final s = (map[key] ?? '').toString().trim();
        if (s.isNotEmpty) return s;
      }
    }
    if (value != null && value is! Map) {
      final s = value.toString().trim();
      if (s.isNotEmpty && s != 'null') return s;
    }
    return '';
  }

  /// Birinchi > 0 qiymatni qaytaradi, topilmasa 0.
  int _firstPositiveInt(List<dynamic> candidates) {
    for (final c in candidates) {
      if (c == null) continue;
      final n = int.tryParse(c.toString());
      if (n != null && n > 0) return n;
    }
    return 0;
  }

  int _parseBadgeId(dynamic value) {
    if (value == null) return 0;
    final n = int.tryParse(value.toString());
    if (n == null || n < 0) return 0;
    return n;
  }

  bool _parseNotificationsEnabled(Map<String, dynamic> data) {
    const keys = <String>[
      'notifications_enabled',
      'notification_enabled',
      'push_notifications_enabled',
      'notificationsEnabled',
      'push_enabled',
    ];
    for (final key in keys) {
      if (!data.containsKey(key)) continue;
      final v = data[key];
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final lower = v.toLowerCase();
        if (lower == 'true' || lower == '1') return true;
        if (lower == 'false' || lower == '0') return false;
      }
    }
    final settings = _asMapOrNull(data['settings']);
    if (settings != null) {
      return _parseNotificationsEnabled(settings);
    }
    return false;
  }

  bool _parseDarkModeEnabled(Map<String, dynamic> data) {
    const keys = <String>['dark_mode', 'darkMode', 'dark_mode_enabled'];
    for (final key in keys) {
      if (!data.containsKey(key)) continue;
      final v = data[key];
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final lower = v.toLowerCase();
        if (lower == 'true' || lower == '1') return true;
        if (lower == 'false' || lower == '0') return false;
      }
    }
    return false;
  }

  int? _readNonNegativeInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (!map.containsKey(key)) continue;
      final raw = map[key];
      if (raw == null) continue;
      final n = int.tryParse(raw.toString());
      if (n != null && n >= 0) return n;
    }
    return null;
  }
}
