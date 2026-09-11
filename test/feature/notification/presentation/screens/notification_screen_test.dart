import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_tile.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_segmented_tab_bar.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/notification_screen.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/bloc/notification_settings_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/settings/notification_settings_screen.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_user_public_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_detail_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget app({
    required Widget home,
    Brightness brightness = Brightness.light,
    List<GoRoute> extraRoutes = const [],
  }) {
    return AppThemeProvider(
      builder: (context) => MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppOptions.lightThemeData(context),
        darkTheme: AppOptions.darkThemeData(context),
        themeMode: brightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark,
        routerConfig: GoRouter(
          initialLocation: '/notification',
          routes: [
            GoRoute(path: '/notification', builder: (_, _) => home),
            GoRoute(
              path: '/portfolio/:postId',
              builder: (_, state) =>
                  Text('post-${state.pathParameters['postId']}'),
            ),
            GoRoute(
              path: '/courses/:id',
              builder: (_, state) =>
                  Text('course-${state.pathParameters['id']}'),
            ),
            ...extraRoutes,
          ],
        ),
      ),
    );
  }

  Future<void> registerSession() async {
    await getIt.reset();
    final cubit = AuthSessionCubit(_FakeAuthRepository());
    await cubit.setRegisteredSession(accessToken: 'a', refreshToken: 'r');
    getIt.registerSingleton<AuthSessionCubit>(cubit);
    getIt.registerSingleton<GuestTapGateService>(GuestTapGateService());
  }

  tearDown(() async {
    await getIt.reset();
  });

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('tab spacing unread dot and divider ${brightness.name}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 970);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await registerSession();
      getIt.registerFactory<NotificationBloc>(
        () => NotificationBloc(
          _FakeListRepository(
            items: [
              _globalItem(),
              NotificationItemModel(
                id: 'p1',
                title: 'Platform ping',
                description: 'Hello',
                createdAt: DateTime.now(),
                channelType: NotificationChannelType.push,
                isRead: false,
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(
        app(home: const NotificationScreen(), brightness: brightness),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Community'), findsOneWidget);
      expect(tester.getSize(find.byType(AppSegmentedTabBar)).height, 56);

      final dots = find.byKey(const ValueKey('notification-unread-dot'));
      expect(dots, findsWidgets);
      expect(tester.getSize(dots.first), const Size(6, 6));
      expect(find.byType(Divider), findsNothing);
    });
  }

  testWidgets('shows actor stack and post thumbnail for social items', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: NotificationTile(
              item: _socialItem(),
              onTap: () {},
              showDivider: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('notification-actor-stack')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('notification-post-thumbnail')),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('notification-actor-stack'))),
      const Size(68, 68),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('notification-post-thumbnail'))),
      const Size(53, 85),
    );
    expect(find.text('liked your post'), findsOneWidget);
  });

  testWidgets('social item opens portfolio route', (tester) async {
    await registerSession();
    getIt.registerFactory<NotificationBloc>(
      () => NotificationBloc(_FakeListRepository(items: [_socialItem()])),
    );
    await tester.pumpWidget(app(home: const NotificationScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(NotificationTile), findsOneWidget);
    tester.widget<NotificationTile>(find.byType(NotificationTile)).onTap();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('post-post-1'), findsOneWidget);
  });

  testWidgets('global item opens detail sheet', (tester) async {
    await registerSession();
    getIt.registerFactory<NotificationBloc>(
      () => NotificationBloc(_FakeListRepository(items: [_globalItem()])),
    );
    await tester.pumpWidget(app(home: const NotificationScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final ctx = tester.element(find.text('Community'));
    ctx.read<NotificationBloc>().add(
      const NotificationTabSelected(NotificationListTab.community),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(NotificationTile), findsOneWidget);
    tester.widget<NotificationTile>(find.byType(NotificationTile)).onTap();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(NotificationDetailSheet), findsOneWidget);
    expect(find.text('Join us today'), findsOneWidget);
  });

  testWidgets('topic switches are disabled when master is off', (tester) async {
    await registerSession();
    getIt.registerFactory<NotificationSettingsBloc>(
      () => NotificationSettingsBloc(
        notificationRepository: _FakeTopicsRepository(),
        profileRepository: _FakeProfileRepository(),
        ensurePushToken: () async => 'token',
      ),
    );
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: const NotificationSettingsScreen(masterEnabled: false),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
    expect(switches, hasLength(2));
    expect(switches.first.onChanged, isNotNull);
    expect(switches.last.onChanged, isNull);
  });

  testWidgets('shows skeleton empty and failure states', (tester) async {
    await registerSession();
    getIt.registerFactory<NotificationBloc>(
      () => NotificationBloc(_DelayedEmptyRepository()),
    );
    await tester.pumpWidget(app(home: const NotificationScreen()));
    await tester.pump();
    expect(find.byType(NotificationListSkeleton), findsWidgets);
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(NotificationEmptyContent), findsOneWidget);

    await getIt.reset();
    await registerSession();
    getIt.registerFactory<NotificationBloc>(
      () => NotificationBloc(_FailingListRepository()),
    );
    await tester.pumpWidget(app(home: const NotificationScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(TgsFailureContent), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}

NotificationItemModel _globalItem() {
  return NotificationItemModel(
    id: 'g1',
    title: 'Course is live',
    description: 'Join us today',
    createdAt: DateTime.now(),
    channelType: NotificationChannelType.global,
    isRead: false,
    targetId: 'course-1',
  );
}

NotificationItemModel _socialItem() {
  return NotificationItemModel(
    id: 's1',
    title: 'Like',
    description: 'liked your post',
    createdAt: DateTime.now(),
    channelType: NotificationChannelType.push,
    isRead: false,
    category: NotificationCategory.postLiked,
    actors: const [
      NotificationActorModel(id: 'a1', firstName: 'A', lastName: 'One'),
      NotificationActorModel(id: 'a2', firstName: 'B', lastName: 'Two'),
    ],
    post: const NotificationPostModel(id: 'post-1'),
  );
}

class _FakeListRepository implements NotificationRepository {
  _FakeListRepository({required this.items});
  final List<NotificationItemModel> items;

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    final filtered = items
        .where((e) => e.channelType == type)
        .toList(growable: false);
    return NotificationPageModel(
      items: filtered,
      pagination: NotificationPaginationModel(
        pageNumber: 1,
        pageSize: pageSize,
        count: filtered.length,
        pageCount: 1,
      ),
    );
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
    throw UnimplementedError();
  }

  @override
  Future<bool> toggleTopic({required String topicId}) async => false;

  @override
  Future<void> subscribePushToken(String token) async {}

  @override
  Future<void> unsubscribePushToken(String token) async {}
}

class _DelayedEmptyRepository extends _FakeListRepository {
  _DelayedEmptyRepository() : super(items: const []);

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return super.fetchPage(
      type: type,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}

class _FailingListRepository extends _FakeListRepository {
  _FailingListRepository() : super(items: const []);

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    throw StateError('failed');
  }
}

class _FakeTopicsRepository implements NotificationRepository {
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
    return const NotificationTopicPageModel(
      items: [
        NotificationTopicModel(id: 't1', topic: 'News', isSubscribed: true),
      ],
      pagination: NotificationPaginationModel(
        pageNumber: 1,
        pageSize: 10,
        count: 1,
        pageCount: 1,
      ),
    );
  }

  @override
  Future<bool> toggleTopic({required String topicId}) async => true;

  @override
  Future<void> subscribePushToken(String token) async {}

  @override
  Future<void> unsubscribePushToken(String token) async {}
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}
  @override
  Future<AuthSessionModel> readSession() async =>
      const AuthSessionModel(userType: UserType.user);
  @override
  Future<AuthSessionModel> refreshToken({required String refreshToken}) async =>
      const AuthSessionModel(userType: UserType.user);
  @override
  Future<String> sendOtpToPhoneNumber({required String phone}) async => 'k';
  @override
  Future<AuthOtpBotResponse> sendOtpViaTelegramBot({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSessionModel> setAnonymousSession() async =>
      const AuthSessionModel(userType: UserType.guest);
  @override
  Future<AuthSessionModel> setRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
  }) async {
    return AuthSessionModel(
      userType: UserType.user,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  @override
  Future<AuthSessionModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  }) async => const AuthSessionModel(userType: UserType.user);

  @override
  Future<AuthSessionModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  }) async => const AuthSessionModel(userType: UserType.user);
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
      notificationsEnabled: false,
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
