import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/bloc/store_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_category_chips.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_product_card.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/components/store_product_grid_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/store_screen_mixin.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({
    super.key,
    this.bottomContentInset = 0,
    this.showBackButton = true,
  });

  final double bottomContentInset;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StoreCatalogBloc>()..add(const StoreCatalogStarted()),
      child: _StoreView(
        bottomContentInset: bottomContentInset,
        showBackButton: showBackButton,
      ),
    );
  }
}

class _StoreView extends StatefulWidget {
  const _StoreView({
    required this.bottomContentInset,
    required this.showBackButton,
  });

  final double bottomContentInset;
  final bool showBackButton;

  @override
  State<_StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<_StoreView>
    with StoreScreenMixin<_StoreView> {
  static const double _headerHeight = 124;

  bool _onScrollNotification(ScrollNotification n, BuildContext context) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) {
      return false;
    }
    final m = n.metrics;
    if (m.pixels >= m.maxScrollExtent - 220) {
      onScrollNearEnd(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final headerExtent = topInset + _headerHeight;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: BlocConsumer<StoreCatalogBloc, StoreCatalogState>(
          listenWhen: (previous, current) =>
              current.loadMoreFailed && !previous.loadMoreFailed,
          listener: storeBlocListener,
          builder: (context, state) {
            final isInitialLoading =
                (state.status == StoreCatalogStatus.loading ||
                    state.status == StoreCatalogStatus.initial) &&
                state.items.isEmpty;

            return Stack(
              children: [
                Positioned.fill(
                  child: switch (state.status) {
                    StoreCatalogStatus.failure when state.items.isEmpty =>
                      Padding(
                        padding: EdgeInsets.only(top: headerExtent),
                        child: TgsFailureContent(
                          message: "Mahsulotlarni yuklashda xatolik",
                          onRetry: () => retryFirstPage(context),
                        ),
                      ),
                    _ when isInitialLoading => SingleChildScrollView(
                      padding: EdgeInsets.only(top: headerExtent),
                      child: const StoreProductGridSkeleton(),
                    ),
                    StoreCatalogStatus.success when state.items.isEmpty =>
                      Padding(
                        padding: EdgeInsets.only(top: headerExtent),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.package2,
                                  size: 48,
                                  color: context.appColors.grey,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Hozircha mahsulot yo'q",
                                  style: context.textTheme.bodyLargeSemibold
                                      .copyWith(color: context.appColors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    _ => NotificationListener<ScrollNotification>(
                      onNotification: (n) => _onScrollNotification(n, context),
                      child: AppStaggeredScrollLimiter(
                        key: ValueKey(
                          'store-grid-${state.selectedCategoryId}-${state.pageNumber}-${state.items.length}',
                        ),
                        child: GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                            12,
                            headerExtent,
                            20,
                            24 + bottomInset + widget.bottomContentInset,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.62,
                              ),
                          itemCount:
                              state.items.length +
                              (state.isLoadingMore ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.items.length) {
                              return Skeletonizer.zone(
                                child: const StoreProductSkeletonCard(),
                              );
                            }
                            final product = state.items[index];
                            return AppStaggeredListItem(
                              position: index,
                              child: StoreProductCard(
                                product: product,
                                onTap: () => onProductTap(
                                  context,
                                  productId: product.id,
                                ),
                                onLikeTap: () =>
                                    onLikeTap(context, productId: product.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerExtent,
                  child: AppBlurredHeaderSurface(
                    child: Padding(
                      padding: EdgeInsets.only(top: topInset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: AppPadding.paddingHorizontalLg,
                            child: buildStoreTopBar(
                              context,
                              showBackButton: widget.showBackButton,
                            ),
                          ),
                          StoreCategoryChips(
                            categories: buildCategoryChips(state),
                            selectedId: state.selectedCategoryId,
                            onSelected: (id) => onCategoryChanged(context, id),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
