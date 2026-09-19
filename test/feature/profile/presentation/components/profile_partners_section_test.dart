import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_partners_section.dart';

void main() {
  testWidgets('ProfilePartnersSection shows partners title and glass layer', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('uz'),
          theme: AppOptions.lightThemeData(context),
          home: const Scaffold(body: ProfilePartnersSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('HAMKORLAR'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('profile-partners-liquid-layer')),
      findsOneWidget,
    );
    expect(find.byType(Image), findsNWidgets(3));
    final agentlikBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('profile-partner-agentlik')),
    );
    expect(agentlikBox.size.height, 22);
    expect(agentlikBox.size.width, greaterThan(0));
  });
}
