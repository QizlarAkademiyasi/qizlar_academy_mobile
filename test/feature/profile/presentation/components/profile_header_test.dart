import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_header.dart';

void main() {
  testWidgets('ProfileHeader shows formatted phone subtitle', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('uz'),
          theme: AppOptions.lightThemeData(context),
          home: const Scaffold(
            body: ProfileHeader(
              user: ProfileUserModel(
                firstName: 'Marjonakhon',
                lastName: 'Jurakulova',
                fullName: 'Marjonakhon Jurakulova',
                userId: '123456',
                phoneNumber: '+998901234567',
                avatarUrl: '',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('+998 90 123-45-67'), findsOneWidget);
  });
}
