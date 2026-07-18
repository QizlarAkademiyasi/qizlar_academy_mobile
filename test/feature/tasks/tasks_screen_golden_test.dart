import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_page_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_pagination_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/repository/tasks_repository.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/screens/tasks_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final loader = FontLoader('Plus Jakarta Sans')
      ..addFont(
        rootBundle.load(
          'packages/qizlar_academy_kit/assets/fonts/PlusJakartaSans-VariableFont_wght.ttf',
        ),
      );
    await loader.load();
    final lucideLoader = FontLoader('packages/lucide_icons_flutter/Lucide')
      ..addFont(
        rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
      );
    await lucideLoader.load();
  });

  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<TasksBloc>(
      () => TasksBloc(
        const _FakeTasksRepository(),
        const _FakeHomeRepository(),
        const _FakeDailyCoinRepository(),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('tasks screen ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(780, 1964);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale('uz'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppOptions.lightThemeData(context),
            darkTheme: AppOptions.darkThemeData(context),
            themeMode: brightness == Brightness.light
                ? ThemeMode.light
                : ThemeMode.dark,
            home: const MediaQuery(
              data: MediaQueryData(
                size: Size(390, 982),
                padding: EdgeInsets.only(top: 47),
              ),
              child: TasksScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TasksScreen),
        matchesGoldenFile('goldens/tasks_screen_${brightness.name}.png'),
      );
    });
  }

  testWidgets('task link opens its internal route', (tester) async {
    tester.view.physicalSize = const Size(390, 982);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/tasks',
      routes: [
        GoRoute(path: '/tasks', builder: (_, _) => const TasksScreen()),
        GoRoute(
          path: '/referral',
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text('Referral destination'))),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Referal qiling'));
    await tester.tap(find.text('Referal qiling'));
    await tester.pumpAndSettle();

    expect(find.text('Referral destination'), findsOneWidget);
  });
}

const _items = <TaskItemModel>[
  TaskItemModel(
    id: 'profile',
    icon: '',
    title: 'Ma’lumot to’ldirish',
    description: 'Bugun kamida bitta darsni oxirigacha ko‘ring',
    coins: 10,
    frequency: TaskFrequency.daily,
    type: TaskType.auto,
    event: TaskEvent.profileFill,
    link: '',
    requiredCount: 1,
    isActive: true,
    startsAt: null,
    endsAt: null,
    createdAt: null,
    isCompleted: true,
    completedCount: 1,
  ),
  TaskItemModel(
    id: 'course',
    icon: '',
    title: 'Bilim sari qadam',
    description: 'Bugun kamida bitta darsni oxirigacha ko‘ring',
    coins: 10,
    frequency: TaskFrequency.daily,
    type: TaskType.auto,
    event: TaskEvent.courseComplete,
    link: '',
    requiredCount: 5,
    isActive: true,
    startsAt: null,
    endsAt: null,
    createdAt: null,
    isCompleted: false,
    completedCount: 1,
  ),
  TaskItemModel(
    id: 'review',
    icon: '',
    title: 'Kursga sharx qoldiring',
    description: 'Bugun kamida bitta darsni oxirigacha ko‘ring',
    coins: 10,
    frequency: TaskFrequency.daily,
    type: TaskType.auto,
    event: TaskEvent.writeCommitToCourse,
    link: '',
    requiredCount: 1,
    isActive: true,
    startsAt: null,
    endsAt: null,
    createdAt: null,
    isCompleted: false,
    completedCount: 0,
  ),
  TaskItemModel(
    id: 'portfolio',
    icon: '',
    title: 'Portfoli yuklasa',
    description: 'Bugun kamida bitta darsni oxirigacha ko‘ring',
    coins: 10,
    frequency: TaskFrequency.daily,
    type: TaskType.auto,
    event: TaskEvent.createPortfolio,
    link: '',
    requiredCount: 1,
    isActive: true,
    startsAt: null,
    endsAt: null,
    createdAt: null,
    isCompleted: false,
    completedCount: 0,
  ),
  TaskItemModel(
    id: 'certificate',
    icon: '',
    title: 'Sertifikat oling',
    description: 'Bugun kamida bitta darsni oxirigacha ko‘ring',
    coins: 10,
    frequency: TaskFrequency.once,
    type: TaskType.auto,
    event: TaskEvent.getCertificate,
    link: '',
    requiredCount: 1,
    isActive: true,
    startsAt: null,
    endsAt: null,
    createdAt: null,
    isCompleted: true,
    completedCount: 1,
  ),
  TaskItemModel(
    id: 'referral',
    icon: 'user-plus',
    title: 'Referal qiling',
    description: 'Bugun kamida bitta darsni oxirigacha ko‘ring',
    coins: 10,
    frequency: TaskFrequency.once,
    type: TaskType.auto,
    event: TaskEvent.unknown,
    link: '/referral',
    requiredCount: 5,
    isActive: true,
    startsAt: null,
    endsAt: null,
    createdAt: null,
    isCompleted: false,
    completedCount: 1,
  ),
];

class _FakeTasksRepository implements TasksRepository {
  const _FakeTasksRepository();

  @override
  Future<TasksPageModel> fetchTasks({
    required int pageNumber,
    required int pageSize,
  }) async {
    return const TasksPageModel(
      items: _items,
      pagination: TasksPaginationModel(
        pageNumber: 1,
        pageSize: 100,
        count: 6,
        pageCount: 1,
      ),
    );
  }
}

class _FakeHomeRepository implements HomeRepository {
  const _FakeHomeRepository();

  @override
  Future<List<BannerModel>> getBanners() async => const [];

  @override
  Future<List<StoryModel>> getCategories() async => const [];

  @override
  Future<List<CourseModel>> getCourses() async => const [];

  @override
  Future<HomeStatsModel> getStats() async => const HomeStatsModel(
    coins: 1250,
    grade: 0,
    rating: 0,
    lastLessonCategory: '',
    lastLessonProgress: 0,
  );

  @override
  Future<List<TeacherModel>> getTeachers() async => const [];

  @override
  Future<void> postStoryView(String storyId) async {}
}

class _FakeDailyCoinRepository implements DailyCoinRepository {
  const _FakeDailyCoinRepository();

  @override
  Future<void> claimStreak() async {}

  @override
  Future<DailyStreakModel> fetchStreak() async {
    return const DailyStreakModel(streakCount: 7, isClaimed: false);
  }
}
