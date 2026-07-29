import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_parser.dart';

void main() {
  final parser = AppDeepLinkParser();

  group('portfolio deep links', () {
    test('accepts a portfolio detail path', () {
      expect(
        parser.parsePathOnly('/portfolio/post-123'),
        '/portfolio/post-123',
      );
    });

    test('accepts the portfolio custom-scheme link', () {
      expect(
        parser.parseUriToLocation(
          Uri.parse('qizlaracademy://portfolio/post-123'),
        ),
        '/portfolio/post-123',
      );
    });

    test('accepts the shared portfolio HTTPS link', () {
      expect(
        parser.parseUriToLocation(
          Uri.parse('https://www.qizlarakademiyasi.uz/portfolio/post-123'),
        ),
        '/portfolio/post-123',
      );
    });

    test('accepts portfolio links from the canonical non-www host', () {
      expect(
        parser.parseUriToLocation(
          Uri.parse('https://qizlarakademiyasi.uz/portfolio/post-123'),
        ),
        '/portfolio/post-123',
      );
    });

    test('rejects create and nested portfolio paths', () {
      expect(parser.parsePathOnly('/portfolio/create'), isNull);
      expect(parser.parsePathOnly('/portfolio/post-123/comments'), isNull);
    });
  });
}
