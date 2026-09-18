import 'dart:convert';

import 'package:flutter/rendering.dart' show debugPaintBaselinesEnabled;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_pinned_app_bar.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    debugPaintBaselinesEnabled = false;
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List<dynamic>;
    for (final entry in manifest) {
      final family = entry['family'] as String;
      if (!family.endsWith('/Plus Jakarta Sans')) continue;
      final loader = FontLoader('Plus Jakarta Sans');
      for (final font in entry['fonts'] as List<dynamic>) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
    final cupertinoLoader =
        FontLoader('packages/cupertino_icons/CupertinoIcons')..addFont(
          rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf'),
        );
    await cupertinoLoader.load();
  });

  for (final dark in [false, true]) {
    for (final collapsed in [false, true]) {
      final themeName = dark ? 'dark' : 'light';
      final stateName = collapsed ? 'collapsed' : 'expanded';

      testWidgets('Home AppBar golden $themeName $stateName', (tester) async {
        tester.view.physicalSize = const Size(390, 236);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          AppThemeProvider(
            builder: (context) => MaterialApp(
              theme: dark
                  ? AppOptions.darkThemeData(context)
                  : AppOptions.lightThemeData(context),
              home: MediaQuery(
                data: const MediaQueryData(
                  size: Size(390, 844),
                  padding: EdgeInsets.only(top: 47),
                ),
                child: RepaintBoundary(
                  key: const ValueKey('home-app-bar-golden-surface'),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const _ColorfulScrollFixture(),
                      Align(
                        alignment: Alignment.topCenter,
                        child: HomePinnedAppBar(
                          title: 'Salom, Rayhon',
                          collapseProgress: collapsed ? 1 : 0,
                          tasksTooltip: 'Vazifalar',
                          notificationTooltip: 'Bildirishnomalar',
                          onTasksTap: _noop,
                          onNotificationTap: _noop,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const ValueKey('home-app-bar-golden-surface')),
          matchesGoldenFile('goldens/home_app_bar_${themeName}_$stateName.png'),
        );
      });
    }
  }
}

void _noop() {}

class _ColorfulScrollFixture extends StatelessWidget {
  const _ColorfulScrollFixture();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF121212)
        : const Color(0xFFF7F7F5);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE8357D).withValues(alpha: 0.52),
            base,
            const Color(0xFF6C63FF).withValues(alpha: 0.46),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _BackdropGridPainter(
              dark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final color in const [
                  Color(0xFFFFFFFF),
                  Color(0xFFE8357D),
                  Color(0xFF6C63FF),
                  Color(0xFF22C55E),
                  Color(0xFFFFFFFF),
                ])
                  Container(
                    height: 12,
                    margin: const EdgeInsets.only(bottom: 4),
                    color: color.withValues(alpha: 0.72),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropGridPainter extends CustomPainter {
  const _BackdropGridPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 8.0;
    final paint = Paint()
      ..color = (dark ? Colors.white : Colors.black).withValues(alpha: 0.22);
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        if (((x / cell).floor() + (y / cell).floor()).isEven) {
          canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BackdropGridPainter oldDelegate) =>
      oldDelegate.dark != dark;
}
