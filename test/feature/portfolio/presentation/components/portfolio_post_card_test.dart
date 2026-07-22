import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_author_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_post_card.dart';

void main() {
  testWidgets('detail metadata wraps without horizontal overflow', (
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
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 354,
                child: PortfolioPostCard(
                  post: _post,
                  isDetail: true,
                  onTap: _noop,
                  onLikeTap: _noop,
                  onCommentTap: _noop,
                  onShareTap: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

void _noop() {}

final _post = PortfolioPostModel(
  id: 'post-123',
  caption: 'Portfolio loyihasi',
  viewsCount: 12500,
  likesCount: 1840,
  commentsCount: 0,
  createdAt: DateTime(2026, 7, 21, 1, 10),
  author: const PortfolioAuthorModel(
    id: 'author-1',
    firstname: 'Qizlar',
    lastname: 'Akademiyasi',
    photoUrl: '',
  ),
  media: const [],
  isLiked: false,
);
