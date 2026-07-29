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
}

class _SuccessfulDailyCoinRepository implements DailyCoinRepository {
  var _isClaimed = false;

  @override
  Future<void> claimStreak() async {
    _isClaimed = true;
  }

  @override
  Future<DailyStreakModel> fetchStreak() async {
    return DailyStreakModel(streakCount: 2, isClaimed: _isClaimed);
  }
}
