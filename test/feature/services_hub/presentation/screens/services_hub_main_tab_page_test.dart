import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/services_hub_main_tab_page.dart';

void main() {
  testWidgets('does not create a hidden WebView before the user plays', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: const Scaffold(body: ServicesHubMainTabPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(InAppWebView), findsNothing);
  });
}
