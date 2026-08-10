import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_item_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_type.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_product_card.dart';

void main() {
  testWidgets('shows a filled heart when the store product is liked', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(isLiked: true));

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(LucideIcons.heart), findsNothing);
  });

  testWidgets('shows an outlined heart when the store product is not liked', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(isLiked: false));

    expect(find.byIcon(LucideIcons.heart), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });

  testWidgets('clips the missing-image placeholder to the card border radius', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(isLiked: false));

    final media = tester.widget<Container>(
      find.byKey(const ValueKey('store-product-media')),
    );
    final decoration = media.decoration! as BoxDecoration;

    expect(media.clipBehavior, Clip.antiAlias);
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect(find.byIcon(LucideIcons.image), findsOneWidget);
  });
}

Widget _testApp({required bool isLiked}) {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(
        body: SizedBox(
          width: 240,
          child: StoreProductCard(
            product: _product.copyWith(isLiked: isLiked),
            onTap: () {},
            onLikeTap: () {},
          ),
        ),
      ),
    ),
  );
}

final _product = StoreProductItemModel(
  id: 'product-1',
  title: 'Test mahsulot',
  basePrice: 1200,
  type: StoreProductType.physical,
  isActive: true,
  categoryId: 'category-1',
  thumbnail: '',
  media: const [],
  variants: const [],
  isLiked: false,
  createdAt: DateTime(2026, 7, 21),
);
