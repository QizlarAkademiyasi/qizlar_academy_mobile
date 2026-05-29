import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_type.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/bloc/store_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_promo_code_sheet.dart';

mixin StoreDetailScreenMixin<T extends StatefulWidget> on State<T> {
  final Map<String, String> selectedAttributeValues = {};

  Map<String, String> resolveSelectedAttributeValues(StoreDetailState state) {
    final product = state.product;
    if (product == null) return selectedAttributeValues;

    final selectedVariant = state.selectedVariant;
    if (selectedVariant != null) {
      for (final group in product.attributeGroups) {
        for (final attr in selectedVariant.attributes) {
          final existsInGroup = group.values.any((v) => v.id == attr.id);
          if (existsInGroup) {
            selectedAttributeValues[group.key] = attr.id;
            break;
          }
        }
      }
    }

    for (final group in product.attributeGroups) {
      if (group.values.length == 1) {
        selectedAttributeValues.putIfAbsent(group.key, () => group.values.first.id);
      }
    }

    return selectedAttributeValues;
  }

  void storeDetailBlocListener(BuildContext context, StoreDetailState state) {
    if (state.orderResult != null) {
      final product = state.product;
      if (product != null && product.type == StoreProductType.promocode && state.orderResult!.promoCode != null) {
        showAppBottomSheet<void>(
          context,
          child: StorePromoCodeSheet(promoCode: state.orderResult!.promoCode!, productTitle: product.title),
        );
      } else {
        AppToast.success(context, message: 'Buyurtma muvaffaqiyatli berildi!');
      }
      context.read<StoreDetailBloc>().add(const StoreDetailOrderResultConsumed());
    }

    if (state.orderError != null) {
      final msg = state.orderError!;
      final normalized = msg.toLowerCase();
      if (normalized.contains('insufficient stock')) {
        AppToast.error(context, message: "Mahsulot tugagan");
      } else if (normalized.contains('no available promo')) {
        AppToast.error(context, message: "Promo kod tugagan");
      } else if (normalized.contains('insufficient coins')) {
        AppToast.error(context, message: "Tangalar yetarli emas");
      } else {
        AppToast.error(context, message: 'Buyurtma berishda xatolik');
      }
      context.read<StoreDetailBloc>().add(const StoreDetailOrderResultConsumed());
    }
  }

  void onBackTap(BuildContext context) {
    context.pop();
  }

  void onLikeTap(BuildContext context) {
    context.read<StoreDetailBloc>().add(const StoreDetailLikeToggled());
  }

  void onOrderTap(BuildContext context) {
    context.read<StoreDetailBloc>().add(const StoreDetailOrderRequested());
  }

  void onAttributeValueSelected(BuildContext context, String key, String valueId, StoreProductDetailModel product) {
    selectedAttributeValues[key] = valueId;
    final matchingVariant = product.variants.where((v) {
      for (final entry in selectedAttributeValues.entries) {
        final hasAttr = v.attributes.any((a) => a.id == entry.value);
        if (!hasAttr) return false;
      }
      return true;
    }).firstOrNull;
    if (matchingVariant != null) {
      context.read<StoreDetailBloc>().add(StoreDetailVariantSelected(variantId: matchingVariant.id));
    }
  }

  String getPurchaseLabel(StoreDetailState state) {
    final product = state.product;
    if (product == null) return '';

    final variant = state.selectedVariant;
    if (variant != null && variant.isSoldOut) return 'Tugagan';

    if (state.orderResult != null) {
      return product.type == StoreProductType.promocode ? "Ko'rish" : 'Qaytarish';
    }

    return 'Sotib olish';
  }

  bool getIsSold(StoreDetailState state) {
    return state.selectedVariant?.isSoldOut ?? false;
  }

  List<String> extractFeatures(String description) {
    final lines = description.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.length <= 1) return const [];
    return lines.skip(1).take(4).toList();
  }
}
