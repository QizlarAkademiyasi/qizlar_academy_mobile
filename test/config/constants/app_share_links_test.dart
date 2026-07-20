import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/config/constants/app_share_links.dart';

void main() {
  group('AppShareLinks.portfolioPostHttpsUrl', () {
    test('builds the portfolio universal link', () {
      expect(
        AppShareLinks.portfolioPostHttpsUrl('post-123'),
        'https://www.qizlarakademiyasi.uz/portfolio/post-123',
      );
    });

    test('trims and safely encodes the post id', () {
      expect(
        AppShareLinks.portfolioPostHttpsUrl(' post / 1 '),
        'https://www.qizlarakademiyasi.uz/portfolio/post%20%2F%201',
      );
    });

    test('falls back to the website for an empty id', () {
      expect(
        AppShareLinks.portfolioPostHttpsUrl('   '),
        AppShareLinks.universalLinkBase,
      );
    });
  });
}
