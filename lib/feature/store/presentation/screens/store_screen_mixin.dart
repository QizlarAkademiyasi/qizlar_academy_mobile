import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/bloc/store_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_category_chips.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_top_bar.dart';

mixin StoreScreenMixin<T extends StatefulWidget> on State<T> {
  void storeBlocListener(BuildContext context, StoreCatalogState state) {
    if (!state.loadMoreFailed) return;
    AppToast.error(context, message: "Ko'proq yuklashda xatolik");
    context.read<StoreCatalogBloc>().add(const StoreCatalogLoadMoreFailureConsumed());
  }

  void onBackTap(BuildContext context) {
    context.pop();
  }

  void onHistoryTap(BuildContext context) {
    context.push(Routes.storeHistory);
  }

  void onProductTap(BuildContext context, {required String productId}) {
    context.push(Routes.storeDetail(productId));
  }

  void onLikeTap(BuildContext context, {required String productId}) {
    context.read<StoreCatalogBloc>().add(StoreCatalogLikeToggled(productId: productId));
  }

  void onCategoryChanged(BuildContext context, String? categoryId) {
    final selected = context.read<StoreCatalogBloc>().state.selectedCategoryId;
    if (selected == categoryId) return;
    context.read<StoreCatalogBloc>().add(StoreCatalogCategoryChanged(categoryId: categoryId));
  }

  void onScrollNearEnd(BuildContext context) {
    context.read<StoreCatalogBloc>().add(const StoreCatalogLoadMoreRequested());
  }

  void retryFirstPage(BuildContext context) {
    context.read<StoreCatalogBloc>().add(const StoreCatalogRetryRequested());
  }

  Widget buildStoreTopBar(BuildContext context) {
    return StoreTopBar(title: 'Market', onBackTap: () => onBackTap(context), onHistoryTap: () => onHistoryTap(context));
  }

  List<StoreCategoryChip> buildCategoryChips(StoreCatalogState state) {
    return [
      const StoreCategoryChip(id: null, label: 'Barchasi'),
      ...state.categories.map((c) => StoreCategoryChip(id: c.id, label: c.name, count: c.productCount > 0 ? c.productCount : null)),
    ];
  }
}
