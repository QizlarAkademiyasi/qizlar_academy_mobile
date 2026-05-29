import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/bloc/store_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_category_chips.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_product_card.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_product_grid_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/store_screen_mixin.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<StoreCatalogBloc>()..add(const StoreCatalogStarted()), child: const _StoreView());
  }
}

class _StoreView extends StatefulWidget {
  const _StoreView();

  @override
  State<_StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<_StoreView> with StoreScreenMixin<_StoreView> {
  bool _onScrollNotification(ScrollNotification n, BuildContext context) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) return false;
    final m = n.metrics;
    if (m.pixels >= m.maxScrollExtent - 220) {
      onScrollNearEnd(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<StoreCatalogBloc, StoreCatalogState>(
          listenWhen: (previous, current) => current.loadMoreFailed && !previous.loadMoreFailed,
          listener: storeBlocListener,
          builder: (context, state) {
            final isInitialLoading = (state.status == StoreCatalogStatus.loading || state.status == StoreCatalogStatus.initial) && state.items.isEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: buildStoreTopBar(context)),
                StoreCategoryChips(categories: buildCategoryChips(state), selectedId: state.selectedCategoryId, onSelected: (id) => onCategoryChanged(context, id)),
                const SizedBox(height: 12),
                Expanded(
                  child: switch (state.status) {
                    StoreCatalogStatus.failure when state.items.isEmpty => TgsFailureContent(message: "Mahsulotlarni yuklashda xatolik", onRetry: () => retryFirstPage(context)),
                    _ when isInitialLoading => const SingleChildScrollView(child: StoreProductGridSkeleton()),
                    StoreCatalogStatus.success when state.items.isEmpty => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.package2, size: 48, color: context.appColors.grey),
                            const SizedBox(height: 12),
                            Text(
                              "Hozircha mahsulot yo'q",
                              style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _ => NotificationListener<ScrollNotification>(
                      onNotification: (n) => _onScrollNotification(n, context),
                      child: AppStaggeredScrollLimiter(
                        key: ValueKey('store-grid-${state.selectedCategoryId}-${state.pageNumber}-${state.items.length}'),
                        child: GridView.builder(
                          padding: EdgeInsets.fromLTRB(12, 0, 20, 24 + bottomInset),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 16, childAspectRatio: 0.62),
                          itemCount: state.items.length + (state.isLoadingMore ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.items.length) {
                              return Skeletonizer.zone(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: BoxDecoration(color: context.appColors.stroke, borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Bone.text(words: 2),
                                  ],
                                ),
                              );
                            }
                            final product = state.items[index];
                            return AppStaggeredListItem(
                              position: index,
                              child: StoreProductCard(
                                product: product,
                                onTap: () => onProductTap(context, productId: product.id),
                                onLikeTap: () => onLikeTap(context, productId: product.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
