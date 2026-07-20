import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_like_button.dart';

void main() {
  testWidgets('shows a filled heart when the portfolio post is liked', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(isLiked: true));

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(LucideIcons.heart), findsNothing);
  });

  testWidgets('shows an outlined heart when the portfolio post is not liked', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(isLiked: false));

    expect(find.byIcon(LucideIcons.heart), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });
}

Widget _testApp({required bool isLiked}) {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(
        body: PortfolioLikeButton(isLiked: isLiked, onTap: () {}),
      ),
    ),
  );
}
