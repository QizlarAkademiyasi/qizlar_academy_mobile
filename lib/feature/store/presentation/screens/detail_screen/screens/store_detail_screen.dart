import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/format/coin_compact_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/bloc/store_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_attribute_selector.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_gallery.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_info_card.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_purchase_bar.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/screens/store_detail_screen_mixin.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoreDetailBloc>()..add(StoreDetailStarted(productId: productId)),
      child: const _StoreDetailView(),
    );
  }
}

class _StoreDetailView extends StatefulWidget {
  const _StoreDetailView();

  @override
  State<_StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<_StoreDetailView> with StoreDetailScreenMixin<_StoreDetailView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreDetailBloc, StoreDetailState>(
      listener: storeDetailBlocListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: switch (state.status) {
              StoreDetailStatus.loading || StoreDetailStatus.initial => const Center(child: Skeletonizer(child: _DetailSkeleton())),
              StoreDetailStatus.failure => TgsFailureContent(message: "Mahsulotni yuklashda xatolik", onRetry: () => context.read<StoreDetailBloc>().add(const StoreDetailRetryRequested())),
              StoreDetailStatus.success => _buildContent(context, state),
            },
          ),
          bottomNavigationBar: state.product != null
              ? StoreDetailPurchaseBar(
                  price: state.selectedVariant?.price ?? state.product!.basePrice,
                  label: getPurchaseLabel(state),
                  onPressed: () => onOrderTap(context),
                  isLoading: state.isOrdering,
                  isSold: getIsSold(state),
                )
              : null,
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, StoreDetailState state) {
    final product = state.product!;
    final resolvedSelectedValues = resolveSelectedAttributeValues(state);
    final imageSize = MediaQuery.sizeOf(context).width - 40;
    final expandedHeight = kToolbarHeight + imageSize + 16;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          expandedHeight: expandedHeight,
          leadingWidth: 56,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
            child: AppBackButton.ghost(onTap: () => onBackTap(context)),
          ),
          title: _CollapsingAppBarTitle(title: product.title),
          flexibleSpace: FlexibleSpaceBar(
            background: _CollapsingAppBarGallery(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 4, 20, 12),
                child: SizedBox.square(
                  dimension: imageSize,
                  child: StoreDetailGallery(media: product.media, showIndicator: false),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(product.title, style: context.textTheme.heading3.copyWith(color: context.appColors.text, fontSize: 26)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.circleStar, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(CoinCompactFormat.short(state.selectedVariant?.price ?? product.basePrice), style: context.textTheme.bodyMediumBold.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
                // if (product.description.isNotEmpty) ...[
                //   const SizedBox(height: 4),
                //   Text(product.description.split('\n').first, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
                // ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.appColors.onContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.appColors.stroke),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.package2, size: 14, color: context.appColors.grey),
                          const SizedBox(width: 4),
                          Text('${product.totalStock} ta omborda', style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (product.attributeGroups.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: StoreDetailAttributeSelector(
                groups: product.attributeGroups,
                selectedValues: resolvedSelectedValues,
                onValueSelected: (key, valueId) => onAttributeValueSelected(context, key, valueId, product),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: StoreDetailInfoCard(description: product.description, features: extractFeatures(product.description)),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 80)),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: context.appColors.stroke, borderRadius: BorderRadius.circular(20)),
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 0), child: Bone.text(words: 3)),
        const Padding(padding: EdgeInsets.fromLTRB(20, 8, 20, 0), child: Bone.text(words: 5)),
      ],
    );
  }
}

class _CollapsingAppBarTitle extends StatelessWidget {
  const _CollapsingAppBarTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final opacity = settings == null ? 1.0 : _collapsedOpacity(settings);
    return Opacity(
      opacity: opacity,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text),
      ),
    );
  }

  double _collapsedOpacity(FlexibleSpaceBarSettings settings) {
    final range = settings.maxExtent - settings.minExtent;
    if (range <= 0) return 1;
    final t = ((settings.currentExtent - settings.minExtent) / range).clamp(0.0, 1.0);
    return (1 - t).clamp(0.0, 1.0);
  }
}

class _CollapsingAppBarGallery extends StatelessWidget {
  const _CollapsingAppBarGallery({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final opacity = settings == null ? 1.0 : _expandedOpacity(settings);
    return Opacity(opacity: opacity, child: child);
  }

  double _expandedOpacity(FlexibleSpaceBarSettings settings) {
    final range = settings.maxExtent - settings.minExtent;
    if (range <= 0) return 0;
    final t = ((settings.currentExtent - settings.minExtent) / range).clamp(0.0, 1.0);
    return Curves.easeOut.transform(t);
  }
}
