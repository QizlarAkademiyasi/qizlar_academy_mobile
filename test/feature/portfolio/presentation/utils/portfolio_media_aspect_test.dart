import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_media_aspect.dart';

void main() {
  tearDown(PortfolioMediaAspectCache.clear);

  group('PortfolioMediaAspect.clampRatio', () {
    test('keeps in-range landscape ratio', () {
      expect(PortfolioMediaAspect.clampRatio(800, 600), closeTo(4 / 3, 0.0001));
    });

    test('clamps tall portrait to 4:5', () {
      expect(PortfolioMediaAspect.clampRatio(1080, 1920), 4 / 5);
    });

    test('clamps wide landscape to 16:9', () {
      expect(PortfolioMediaAspect.clampRatio(1920, 800), 16 / 9);
    });

    test('falls back when width or height is invalid', () {
      expect(PortfolioMediaAspect.clampRatio(0, 600), 1);
      expect(PortfolioMediaAspect.clampRatio(800, 0), 1);
      expect(PortfolioMediaAspect.clampRatio(-10, 600), 1);
      expect(PortfolioMediaAspect.clampRatio(800, -1), 1);
    });
  });

  group('PortfolioMediaAspect.fallbackRatio', () {
    test('uses square for images and 16:9 for videos', () {
      expect(PortfolioMediaAspect.fallbackRatio(isVideo: false), 1);
      expect(PortfolioMediaAspect.fallbackRatio(isVideo: true), 16 / 9);
    });
  });

  group('PortfolioMediaAspectCache', () {
    test('stores and returns ratio by trimmed url', () {
      PortfolioMediaAspectCache.set(' https://cdn.example/a.jpg ', 0.8);
      expect(PortfolioMediaAspectCache.get('https://cdn.example/a.jpg'), 0.8);
    });

    test('ignores empty urls', () {
      PortfolioMediaAspectCache.set('  ', 1.5);
      expect(PortfolioMediaAspectCache.get(''), isNull);
    });
  });
}
