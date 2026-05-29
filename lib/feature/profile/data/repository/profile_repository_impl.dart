import 'package:qizlar_academy_mobile/config/constants/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/profile_edit_pending_patch.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileApiDatasource apiDatasource,
    required AuthSessionCubit authSessionCubit,
  }) : _apiDatasource = apiDatasource,
       _authSessionCubit = authSessionCubit;

  final ProfileApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('Profile endpoints are available only for registered users.');
    }
  }

  @override
  Future<ProfileOverviewModel> getProfileOverview() {
    _ensureRegistered();
    return _apiDatasource.getProfileOverview();
  }

  @override
  Future<ProfileUserPublicModel> getUserProfileById(String id) {
    return _apiDatasource.getUserProfileById(id);
  }

  @override
  Future<ProfileOverviewModel> updateNotifications({required bool enabled}) {
    _ensureRegistered();
    return _apiDatasource.updateNotifications(enabled: enabled);
  }

  @override
  Future<ProfileOverviewModel> updateDarkMode({required bool enabled}) {
    _ensureRegistered();
    return _apiDatasource.updateDarkMode(enabled: enabled);
  }

  @override
  Future<ProfileOverviewModel> updateLanguage({required String code}) {
    _ensureRegistered();
    return _apiDatasource.updateLanguage(code: code);
  }

  @override
  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  }) {
    _ensureRegistered();
    return _apiDatasource.updatePersonalInfo(
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<String> uploadProfilePhoto(String localFilePath) {
    _ensureRegistered();
    return _apiDatasource.uploadProfilePhoto(localFilePath);
  }

  @override
  Future<void> deleteMyAccount() async {
    _ensureRegistered();
    await _apiDatasource.deleteMyAccount();
    await _authSessionCubit.clearSession();
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
  }

  @override
  Future<ProfileOverviewModel?> patchMyProfileIfChanged({
    required ProfileUserModel baseline,
    required String firstName,
    required String lastName,
    required String occupation,
    String? uploadedPhotoFilename,
    required int selectedBadgeId,
    RegionModel? selectedRegion,
    DistrictModel? selectedDistrict,
    NeighborhoodModel? selectedNeighborhood,
    RegionModel? baselineRegion,
    DistrictModel? baselineDistrict,
    NeighborhoodModel? baselineNeighborhood,
    DateTime? selectedBirthday,
    EducationType? selectedEducationType,
  }) async {
    _ensureRegistered();
    final body = <String, dynamic>{};
    final f = firstName.trim();
    final l = lastName.trim();
    final o = occupation.trim();
    if (f != baseline.firstName.trim()) {
      body['firstname'] = f;
    }
    if (l != baseline.lastName.trim()) {
      body['lastname'] = l;
    }
    if (o != baseline.occupation.trim()) {
      body['occupation'] = o;
    }
    if (selectedBadgeId != baseline.badgeId) {
      body['badge'] = selectedBadgeId;
    }
    if (profilePhotoWouldPatch(baseline.avatarUrl, uploadedPhotoFilename)) {
      body['photo'] = uploadedPhotoFilename!.trim();
    }
    // Manzil
    if (selectedRegion?.id != baselineRegion?.id) {
      if (selectedRegion != null) {
        body['regionId'] = selectedRegion.id;
        body['countryId'] = selectedRegion.countryId;
      }
    }
    if (selectedDistrict?.id != baselineDistrict?.id) {
      if (selectedDistrict != null) {
        body['districtId'] = selectedDistrict.id;
      }
    }
    if (selectedNeighborhood?.id != baselineNeighborhood?.id) {
      if (selectedNeighborhood != null) {
        body['neighborhoodId'] = selectedNeighborhood.id;
      }
    }
    // Tug'ilgan sana
    if (selectedBirthday != null && selectedBirthday != baseline.birthday) {
      body['birthday'] = '${selectedBirthday.year}-${selectedBirthday.month.toString().padLeft(2, '0')}-${selectedBirthday.day.toString().padLeft(2, '0')}';
    }
    // Ta'lim turi
    if (selectedEducationType != null && selectedEducationType != baseline.educationType) {
      body['educationId'] = selectedEducationType.patchEducationId;
    }
    if (body.isEmpty) {
      return null;
    }
    await _apiDatasource.patchUserMe(body);
    return getProfileOverview();
  }
}
