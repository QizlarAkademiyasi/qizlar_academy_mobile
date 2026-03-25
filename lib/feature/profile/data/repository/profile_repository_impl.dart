import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileApiDatasource apiDatasource,
  }) : _apiDatasource = apiDatasource;

  final ProfileApiDatasource _apiDatasource;

  @override
  Future<ProfileOverviewModel> getProfileOverview() => _apiDatasource.getProfileOverview();

  @override
  Future<ProfileOverviewModel> updateNotifications({required bool enabled}) =>
      _apiDatasource.updateNotifications(enabled: enabled);

  @override
  Future<ProfileOverviewModel> updateDarkMode({required bool enabled}) =>
      _apiDatasource.updateDarkMode(enabled: enabled);

  @override
  Future<ProfileOverviewModel> updateLanguage({required String code}) =>
      _apiDatasource.updateLanguage(code: code);

  @override
  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  }) => _apiDatasource.updatePersonalInfo(
    firstName: firstName,
    lastName: lastName,
  );
}
