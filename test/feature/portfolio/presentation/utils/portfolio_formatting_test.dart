import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_formatting.dart';

void main() {
  group('portfolio date formatting', () {
    testWidgets('shows the full year in post details', (tester) async {
      final result = await _formatInUzLocale(
        tester,
        () => PortfolioFormatting.detailDate(DateTime(2026, 6, 24)),
      );

      expect(result, matches(RegExp(r'\b2026$')));
      expect(result, isNot(matches(RegExp(r'\b26$'))));
    });

    testWidgets('shows the full year for older posts', (tester) async {
      final result = await _formatInUzLocale(
        tester,
        () => PortfolioFormatting.relativeTime(DateTime(2000, 6, 24)),
      );

      expect(result, endsWith('2000'));
    });
  });
}

Future<String> _formatInUzLocale(
  WidgetTester tester,
  String Function() formatter,
) async {
  late String result;

  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          result = formatter();
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  return result;
}
