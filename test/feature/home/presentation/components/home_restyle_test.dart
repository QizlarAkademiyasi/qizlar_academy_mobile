import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_stats_section.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_ambient_background.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_courses_section.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_banners_carousel.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';

const _featuredCourses = [
  CourseModel(
    id: '1',
    title: 'Milliy taqinchoqlar yasash',
    author: 'Mohina Jabborova',
    imageUrl: '',
    durationSeconds: 7440,
    studentCount: 1200,
  ),
  CourseModel(
    id: '2',
    title: 'Qizlar salomatligi',
    author: 'Sevara Raxmonova',
    imageUrl: '',
    durationSeconds: 7020,
    studentCount: 800,
  ),
  CourseModel(
    id: '3',
    title: 'Eko kolbasa tayyorlash',
    author: 'Dilorom Soatova',
    imageUrl: '',
    durationSeconds: 7020,
    studentCount: 400,
  ),
  CourseModel(
    id: '4',
    title: "To'g'ri ovqatlanish",
    author: 'Mohina Jabborova',
    imageUrl: '',
    durationSeconds: 7440,
    studentCount: 500,
  ),
  CourseModel(
    id: '5',
    title: 'Kiyinish madaniyati',
    author: 'Sevara Raxmonova',
    imageUrl: '',
    durationSeconds: 7020,
    studentCount: 300,
  ),
];

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List<dynamic>;
    for (final entry in manifest) {
      final family = entry['family'] as String;
      final loader = FontLoader(family);
      for (final font in entry['fonts'] as List<dynamic>) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
      if (family.endsWith('/Plus Jakarta Sans')) {
        final alias = FontLoader('Plus Jakarta Sans');
        for (final font in entry['fonts'] as List<dynamic>) {
          alias.addFont(rootBundle.load(font['asset'] as String));
        }
        await alias.load();
      }
    }
  });
  for (final dark in [false, true]) {
    for (final scale in [1.0, 1.5]) {
      testWidgets('Home stats without last lesson; dark=$dark scale=$scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final key = GlobalKey();
        var tapped = 0;
        var courseTaps = 0;
        var allTaps = 0;
        await tester.pumpWidget(
          AppThemeProvider(
            builder: (context) => MaterialApp(
              locale: const Locale('uz'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: dark
                  ? AppOptions.darkThemeData(context)
                  : AppOptions.lightThemeData(context),
              home: MediaQuery(
                data: MediaQueryData(
                  size: const Size(390, 844),
                  textScaler: TextScaler.linear(scale),
                ),
                child: RepaintBoundary(
                  key: key,
                  child: Scaffold(
                    backgroundColor: dark
                        ? const Color(0xFF171717)
                        : const Color(0xFFF7F7F5),
                    body: Stack(
                      children: [
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: HomeAmbientBackground(),
                        ),
                        ListView(
                          children: [
                            const SizedBox(height: 64),
                            const HomeHeaderComponent(title: 'Salom, Rayhon'),
                            const SizedBox(height: 36),
                            HomeStatsSection(
                              stats: const HomeStatsModel(
                                coins: 127,
                                grade: 3,
                                rating: 82,
                                lastLessonCategory: '',
                                lastLessonProgress: 0,
                              ),
                              onCoinsAndGradeTap: () => tapped++,
                            ),
                            const SizedBox(height: 28),
                            HomeCoursesSection(
                              courses: _featuredCourses,
                              onCourseTap: (_) => courseTaps++,
                              onAllCoursesTap: () => allTaps++,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('127'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('82'), findsOneWidget);
        expect(find.text('Seriya'), findsNothing);
        expect(find.text('Kurslar'), findsOneWidget);
        expect(find.text('Barcha kurslar'), findsOneWidget);
        expect(find.text("Ko'rish"), findsOneWidget);
        expect(find.byType(HomeCourseCard), findsNWidgets(5));
        final first = tester.getTopLeft(find.byType(HomeCourseCard).at(0));
        final second = tester.getTopLeft(find.byType(HomeCourseCard).at(1));
        expect(second.dx, greaterThan(first.dx));
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('127'));
        expect(tapped, 1);
        await tester.tap(find.byType(HomeCourseCard).at(1));
        expect(courseTaps, 1);
        await tester.ensureVisible(find.text('Barcha kurslar'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Barcha kurslar'));
        expect(allTaps, 1);
        await tester.pumpAndSettle();
        if (!dark && scale == 1) {
          await tester.runAsync(() async {
            final boundary =
                key.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await boundary.toImage();
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            await File(
              'build/home_restyle_preview.png',
            ).writeAsBytes(data!.buffer.asUint8List());
            image.dispose();
          });
        }
      });
    }
  }

  for (final width in [320.0, 390.0]) {
    testWidgets('Home courses grid is two columns at $width', (tester) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            locale: const Locale('uz'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppOptions.lightThemeData(context),
            home: MediaQuery(
              data: MediaQueryData(size: Size(width, 844)),
              child: Scaffold(
                body: HomeCoursesSection(
                  courses: _featuredCourses,
                  onCourseTap: (_) {},
                  onAllCoursesTap: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final first = tester.getTopLeft(find.byType(HomeCourseCard).at(0));
      final second = tester.getTopLeft(find.byType(HomeCourseCard).at(1));
      expect(second.dx, greaterThan(first.dx));
      expect(second.dy, closeTo(first.dy, 2));
      expect(find.text('Barcha kurslar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Home banner card height is constrained inside stretch slack', (
    tester,
  ) async {
    const width = 390.0;
    tester.view.physicalSize = const Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: MediaQuery(
            data: const MediaQueryData(size: Size(width, 844)),
            child: const Scaffold(
              body: HomeBannersCarousel(
                autoPlay: false,
                banners: [
                  BannerModel(id: '1', title: '', subtitle: '', imageUrl: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    final expectedCard = (width - 48) * 182 / 342;
    expect(
      tester.getSize(find.byKey(const ValueKey('home-banner-card'))).height,
      expectedCard,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('home-banner-viewport'))).height,
      expectedCard + HomeBannersCarousel.stretchSlack * 2,
    );
    expect(tester.takeException(), isNull);
  });
}
