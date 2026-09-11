import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_media_preview.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_media_aspect.dart';

void main() {
  tearDown(PortfolioMediaAspectCache.clear);

  testWidgets('portrait media is taller than landscape at the same width', (
    tester,
  ) async {
    const portraitUrl = 'https://cdn.example/portrait.jpg';
    const landscapeUrl = 'https://cdn.example/landscape.jpg';
    PortfolioMediaAspectCache.set(portraitUrl, 4 / 5);
    PortfolioMediaAspectCache.set(landscapeUrl, 16 / 9);

    await _pumpPreview(tester, media: [_media(id: 'p', url: portraitUrl)]);
    final portraitHeight = tester
        .getSize(find.byKey(const ValueKey<String>('portfolio-media-tile-0')))
        .height;

    await _pumpPreview(tester, media: [_media(id: 'l', url: landscapeUrl)]);
    final landscapeHeight = tester
        .getSize(find.byKey(const ValueKey<String>('portfolio-media-tile-0')))
        .height;

    expect(portraitHeight, closeTo(390 / (4 / 5), 0.5));
    expect(landscapeHeight, closeTo(390 / (16 / 9), 0.5));
    expect(portraitHeight, greaterThan(landscapeHeight));
    expect(find.byType(AspectRatio), findsOneWidget);
  });

  testWidgets('empty preview url uses fallback box without throwing', (
    tester,
  ) async {
    await _pumpPreview(tester, media: [_media(id: 'empty', url: '')]);

    final size = tester.getSize(
      find.byKey(const ValueKey<String>('portfolio-media-tile-0')),
    );
    expect(size.width, 390);
    expect(size.height, 390);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 390.0]) {
    testWidgets('horizontal media list scrolls at $width', (tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pumpPreview(
        tester,
        width: width,
        media: List<PortfolioMediaModel>.generate(
          8,
          (index) => _media(id: '$index', url: ''),
        ),
      );

      final list = find.byKey(const ValueKey<String>('portfolio-media-list'));
      final scroll = find.descendant(
        of: list,
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scroll).position;
      final tileWidth = tester
          .getSize(find.byKey(const ValueKey<String>('portfolio-media-tile-0')))
          .width;

      expect(position.maxScrollExtent, greaterThan(0));
      expect(tileWidth, closeTo(width * 0.68, 0.5));

      await tester.drag(list, const Offset(-280, 0));
      await tester.pump(const Duration(milliseconds: 500));
      expect(position.pixels, greaterThan(0));
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _pumpPreview(
  WidgetTester tester, {
  required List<PortfolioMediaModel> media,
  double width = 390,
}) async {
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
              width: width,
              child: PortfolioMediaPreview(media: media, borderRadius: 8),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

PortfolioMediaModel _media({required String id, required String url}) {
  return PortfolioMediaModel(
    id: id,
    type: PortfolioMediaType.image,
    url: url,
    thumbnailUrl: '',
    duration: null,
    orderIndex: 0,
  );
}
