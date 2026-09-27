import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen.dart';

class _UnusedCoursesCatalogRepository implements CoursesCatalogRepository {
  @override
  Future<CoursesCatalogOverviewModel> fetchCatalog({required String query}) {
    fail('catalog fetch should not run for the initial skeleton frame');
  }
}

void main() {
  testWidgets(
    'shell CoursesCatalogBloc shows skeleton before catalog data arrives',
    (tester) async {
      final bloc = CoursesCatalogBloc(_UnusedCoursesCatalogRepository());
      addTearDown(bloc.close);

      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('uz'),
            theme: AppOptions.lightThemeData(context),
            home: BlocProvider.value(
              value: bloc,
              child: const CoursesScreen(
                key: ValueKey('main-tab-courses'),
                bottomContentInset: 72,
                showBackButton: false,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester
            .element(find.byKey(const ValueKey('main-tab-courses')))
            .read<CoursesCatalogBloc>(),
        same(bloc),
      );
      expect(find.byType(CoursesListSkeleton), findsOneWidget);
      expect(bloc.state.hasData, isFalse);
      expect(bloc.state.status, CoursesCatalogStatus.initial);
    },
  );
}
