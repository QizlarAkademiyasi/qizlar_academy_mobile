import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_gallery.dart';

void main() {
  for (final showIndicator in [false, true]) {
    testWidgets('uses contain fit when showIndicator is $showIndicator', (
      tester,
    ) async {
      await tester.pumpWidget(_testApp(showIndicator: showIndicator));

      final image = tester.widget<AppCachedNetworkImage>(
        find.byType(AppCachedNetworkImage),
      );

      expect(image.fit, BoxFit.contain);
    });
  }
}

Widget _testApp({required bool showIndicator}) {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox.square(
            dimension: 320,
            child: StoreDetailGallery(
              media: const [
                StoreMediaModel(
                  id: 'media-1',
                  url: 'https://example.com/product.png',
                ),
              ],
              showIndicator: showIndicator,
            ),
          ),
        ),
      ),
    ),
  );
}
