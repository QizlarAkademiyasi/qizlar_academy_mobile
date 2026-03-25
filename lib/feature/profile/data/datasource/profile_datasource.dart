import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

abstract interface class ProfileDatasource {
  Future<ProfileOverviewModel> getProfileOverview();

  Future<ProfileOverviewModel> updateNotifications({required bool enabled});

  Future<ProfileOverviewModel> updateDarkMode({required bool enabled});

  Future<ProfileOverviewModel> updateLanguage({required String code});

  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  });
}
