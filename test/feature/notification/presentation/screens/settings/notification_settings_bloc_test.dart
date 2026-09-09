import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/bloc/notification_settings_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';

void main() {
  test('rolls back topic toggle when API fails', () async {
    final notificationRepository = _FakeTopicsRepository()..failToggle = true;
    final bloc = NotificationSettingsBloc(
      notificationRepository: notificationRepository,
      profileRepository: _FakeProfileRepository(),
      ensurePushToken: () async => 'token',
    );
    addTearDown(bloc.close);

    bloc.add(const NotificationSettingsStarted(masterEnabled: true));
    await bloc.stream.firstWhere(
      (s) => s.status == NotificationSettingsStatus.success,
    );

    bloc.add(
      const NotificationSettingsTopicToggled(topicId: 't1', enabled: false),
    );
    final failed = await bloc.stream.firstWhere(
      (s) => s.updateFailureVersion == 1,
    );
    expect(failed.topics.single.isSubscribed, isTrue);
  });

  test('does not toggle topic while master is off', () async {
    final notificationRepository = _FakeTopicsRepository();
    final bloc = NotificationSettingsBloc(
      notificationRepository: notificationRepository,
      profileRepository: _FakeProfileRepository(),
      ensurePushToken: () async => 'token',
    );
    addTearDown(bloc.close);
    bloc.add(const NotificationSettingsStarted(masterEnabled: false));
    await bloc.stream.firstWhere(
      (s) => s.status == NotificationSettingsStatus.success,
    );

    bloc.add(
      const NotificationSettingsTopicToggled(topicId: 't1', enabled: false),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(notificationRepository.toggleCalls, 0);
    expect(bloc.state.topics.single.isSubscribed, isTrue);
  });
}

class _FakeTopicsRepository implements NotificationRepository {
  bool failToggle = false;
  int toggleCalls = 0;

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> markAllAsRead() async {}

  @override
  Future<void> markAsRead({required String notificationId}) async {}

  @override
  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    return NotificationTopicPageModel(
      items: const [
        NotificationTopicModel(id: 't1', topic: 'News', isSubscribed: true),
      ],
      pagination: const NotificationPaginationModel(
        pageNumber: 1,
        pageSize: 10,
        count: 1,
        pageCount: 1,
      ),
    );
  }

  @override
  Future<bool> toggleTopic({required String topicId}) async {
    toggleCalls += 1;
    if (failToggle) throw StateError('toggle failed');
    return false;
  }
}

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<ProfileOverviewModel> getProfileOverview() async {
    return const ProfileOverviewModel(
      user: ProfileUserModel(
        firstName: 'A',
        lastName: 'B',
        fullName: 'A B',
        userId: '1',
        phoneNumber: '+998',
        avatarUrl: '',
      ),
      stats: [],
      bankFilters: [],
      achievements: [],
      settings: [],
      general: [],
      languageOptions: [],
      selectedLanguageCode: 'uz',
      notificationsEnabled: true,
      darkModeEnabled: false,
      versionName: '1.0',
    );
  }

  @override
  Future<ProfileOverviewModel> updateNotifications({required bool enabled}) {
    throw UnimplementedError();
  }

  @override
  Future<ProfileOverviewModel> updateDarkMode({required bool enabled}) {
    throw UnimplementedError();
  }

  @override
  Future<ProfileOverviewModel> updateLanguage({required String code}) {
    throw UnimplementedError();
  }

  @override
  Future<ProfileOverviewModel> updatePersonalInfo({
    required String firstName,
    required String lastName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfilePhoto(String localFilePath) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMyAccount() {
    throw UnimplementedError();
  }

  @override
  Future<ProfileUserPublicModel> getUserProfileById(String id) {
    throw UnimplementedError();
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
  }) {
    throw UnimplementedError();
  }
}
