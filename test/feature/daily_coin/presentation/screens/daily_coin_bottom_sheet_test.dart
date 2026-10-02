import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/bloc/daily_coin_bloc.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/screens/daily_coin_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _SuccessfulDailyCoinRepository repository;

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    getIt.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    );
    repository = _SuccessfulDailyCoinRepository();
    getIt.registerFactory<DailyCoinBloc>(() => DailyCoinBloc(repository));
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('closes the bottom sheet after claim succeeds', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDailyCoinBottomSheet(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Olish'), findsOneWidget);

    await tester.tap(find.text('Olish'));
    await tester.pumpAndSettle();

    expect(find.text('Olish'), findsNothing);
  });

  testWidgets('does not show a button when the daily coin is already claimed', (
    tester,
  ) async {
    repository._isClaimed = true;

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDailyCoinBottomSheet(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Olish'), findsNothing);
    expect(find.text('Olingan'), findsNothing);
  });

  testWidgets('auto sheet uses prefetched streak without another GET', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => tryAutopresentDailyCoinSheetFromHomePrefetch(
                  context,
                  const DailyStreakModel(streakCount: 4, isClaimed: false),
                ),
                child: const Text('Open prefetched'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open prefetched'));
    await tester.pumpAndSettle();

    expect(find.text('Olish'), findsOneWidget);
    expect(repository.fetchCount, 0);
  });

  testWidgets('auto sheet stays closed for an already claimed streak', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => tryAutopresentDailyCoinSheetFromHomePrefetch(
                  context,
                  const DailyStreakModel(streakCount: 4, isClaimed: true),
                ),
                child: const Text('Try claimed'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Try claimed'));
    await tester.pumpAndSettle();

    expect(find.text('Olish'), findsNothing);
    expect(repository.fetchCount, 0);
  });
}

class _SuccessfulDailyCoinRepository implements DailyCoinRepository {
  var _isClaimed = false;
  var fetchCount = 0;

  @override
  Future<void> claimStreak() async {
    _isClaimed = true;
  }

  @override
  Future<DailyStreakModel> fetchStreak() async {
    fetchCount++;
    return DailyStreakModel(streakCount: 2, isClaimed: _isClaimed);
  }
}
