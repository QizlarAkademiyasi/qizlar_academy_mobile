import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/format/coin_compact_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/bloc/order_detail/store_order_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_gallery.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_info_card.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_detail_purchase_bar.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/components/store_promo_code_sheet.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/screens/order_detail/store_order_detail_screen_mixin.dart';

class StoreOrderDetailScreen extends StatelessWidget {
  const StoreOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoreOrderDetailBloc>()..add(StoreOrderDetailStarted(orderId: orderId)),
      child: const _StoreOrderDetailView(),
    );
  }
}

class _StoreOrderDetailView extends StatefulWidget {
  const _StoreOrderDetailView();

  @override
  State<_StoreOrderDetailView> createState() => _StoreOrderDetailViewState();
}

class _StoreOrderDetailViewState extends State<_StoreOrderDetailView> with StoreOrderDetailScreenMixin<_StoreOrderDetailView> {
  static const double _pickupLat = 41.320234;
  static const double _pickupLon = 69.262229;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreOrderDetailBloc, StoreOrderDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: switch (state.status) {
              StoreOrderDetailStatus.loading || StoreOrderDetailStatus.initial => const Center(child: Skeletonizer(child: _OrderDetailSkeleton())),
              StoreOrderDetailStatus.failure => TgsFailureContent(
                message: "Buyurtmani yuklashda xatolik",
                onRetry: () => context.read<StoreOrderDetailBloc>().add(const StoreOrderDetailRetryRequested()),
              ),
              StoreOrderDetailStatus.success => _buildContent(context, state.order!),
            },
          ),
          bottomNavigationBar: state.status == StoreOrderDetailStatus.success ? _buildBottomBar(context, state.order!) : null,
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, StoreOrderModel order) {
    final media = order.productMedia.map((url) => StoreMediaModel(id: url, url: url)).toList(growable: false);
    final createdAt = '${order.createdAt.day.toString().padLeft(2, '0')}.${order.createdAt.month.toString().padLeft(2, '0')}.${order.createdAt.year}';
    final imageSize = MediaQuery.sizeOf(context).width - 40;
    final expandedHeight = kToolbarHeight + imageSize + 16;

    final isPromo = (order.productType ?? '').toUpperCase() == 'PROMOCODE';
    final shouldShowMap = !isPromo && !_isOrderReceived(order.status);

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
          title: _CollapsingAppBarTitle(title: order.productTitle.isNotEmpty ? order.productTitle : 'Mahsulot'),
          flexibleSpace: FlexibleSpaceBar(
            background: _CollapsingAppBarGallery(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 4, 20, 12),
                child: SizedBox.square(
                  dimension: imageSize,
                  child: StoreDetailGallery(media: media, showIndicator: false),
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
                      child: Text(order.productTitle.isNotEmpty ? order.productTitle : 'Mahsulot', style: context.textTheme.heading3.copyWith(color: context.appColors.text, fontSize: 26)),
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
                          Text(CoinCompactFormat.short(order.unitPrice), style: context.textTheme.bodyMediumBold.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(createdAt, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
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
                          Icon(LucideIcons.packageCheck, size: 14, color: context.appColors.grey),
                          const SizedBox(width: 4),
                          Text(_resolveStatusLabel(order.status), style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (order.variantAttributes.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: order.variantAttributes
                    .map(
                      (a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.appColors.stroke),
                          color: context.appColors.onContainer,
                        ),
                        child: Text('${a.key}: ${a.value}', style: context.textTheme.bodySmallSemibold.copyWith(color: context.appColors.text)),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        if (shouldShowMap)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppLiquidStretch(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openPickupInYandexMaps(context),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.appColors.stroke),
                        color: context.appColors.onContainer,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.12),
                            ),
                            child: const Icon(LucideIcons.mapPin, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Olib ketish manzili",
                                  style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Yoshlar agentligi',
                                  style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.text),
                                ),
                              ],
                            ),
                          ),
                          Icon(LucideIcons.externalLink, color: context.appColors.grey, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if ((order.productDescription ?? '').isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: StoreDetailInfoCard(description: order.productDescription!, features: _extractFeatures(order.productDescription!)),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 80)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, StoreOrderModel order) {
    final isPromo = (order.productType ?? '').toUpperCase() == 'PROMOCODE';
    final hasPromoCode = order.promoCode != null && order.promoCode!.isNotEmpty;

    return StoreDetailPurchaseBar(
      price: order.unitPrice,
      label: isPromo ? "Ko'rish" : "Olingan",
      onPressed: isPromo && hasPromoCode
          ? () => showAppBottomSheet<void>(
              context,
              child: StorePromoCodeSheet(promoCode: order.promoCode!, productTitle: order.productTitle.isEmpty ? 'Promo kod' : order.productTitle),
            )
          : null,
      isLoading: false,
      isSold: !(isPromo && hasPromoCode),
    );
  }

  String _resolveStatusLabel(String status) {
    return switch (status.toUpperCase()) {
      'PENDING' => "Jarayonda",
      'PAID' => "To'langan",
      'SHIPPED' => "Yuborilgan",
      'DELIVERED' => "Topshirildi",
      'CANCELLED' || 'REFUNDED' => "Bekor qilingan",
      _ => status,
    };
  }

  bool _isOrderReceived(String status) {
    return status.toUpperCase() == 'DELIVERED';
  }

  Future<void> _openPickupInYandexMaps(BuildContext context) async {
    final yandexAppUri = Uri.parse('yandexmaps://maps.yandex.com/?pt=$_pickupLon,$_pickupLat&z=16');
    final yandexWebUri = Uri.parse('https://yandex.com/maps/?pt=$_pickupLon,$_pickupLat&z=16');

    if (await canLaunchUrl(yandexAppUri)) {
      await launchUrl(yandexAppUri, mode: LaunchMode.externalApplication);
      return;
    }

    final launched = await launchUrl(yandexWebUri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppToast.error(context, message: "Xaritani ochib bo'lmadi");
    }
  }

  List<String> _extractFeatures(String description) {
    final lines = description.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.length <= 1) return const [];
    return lines.skip(1).take(4).toList();
  }
}

class _OrderDetailSkeleton extends StatelessWidget {
  const _OrderDetailSkeleton();

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
