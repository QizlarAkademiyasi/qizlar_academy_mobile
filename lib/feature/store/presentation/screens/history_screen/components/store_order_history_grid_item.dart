import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/format/coin_compact_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';

class StoreOrderHistoryGridItem extends StatelessWidget {
  const StoreOrderHistoryGridItem({super.key, required this.order, this.onTap});

  final StoreOrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr = '${order.createdAt.day.toString().padLeft(2, '0')}.${order.createdAt.month.toString().padLeft(2, '0')}';
    final title = order.productTitle.isNotEmpty ? order.productTitle : 'Buyurtma';
    final firstAttr = order.variantAttributes.isNotEmpty ? order.variantAttributes.first.value : null;
    final hasPromo = order.promoCode != null && order.promoCode!.isNotEmpty;

    return AppLiquidStretch(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColors.onContainer.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.stroke.withValues(alpha: 0.7)),
              boxShadow: [BoxShadow(color: AppColors.shadow.withValues(alpha: 0.14), blurRadius: 18, offset: const Offset(0, 10))],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: order.productThumbnail.isNotEmpty
                              ? AppCachedNetworkImage(imageUrl: order.productThumbnail, fit: BoxFit.cover, fallback: const AppNetworkImageFallbackCourse())
                              : Container(
                                  color: context.appColors.stroke,
                                  child: Center(child: Icon(LucideIcons.package2, size: 26, color: context.appColors.grey)),
                                ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.22)]),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: StoreOrderHistoryStatusBadge(status: order.status),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.circleDot, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${CoinCompactFormat.short(order.unitPrice)} tanga',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmallSemibold.copyWith(color: AppColors.primary),
                      ),
                    ),
                    Text(dateStr, style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey, fontSize: 11)),
                  ],
                ),
                if (firstAttr != null || hasPromo) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (firstAttr != null)
                        _MetaTag(
                          icon: LucideIcons.tag,
                          label: firstAttr,
                        ),
                      if (hasPromo)
                        const _MetaTag(
                          icon: LucideIcons.ticketPercent,
                          label: 'Promo',
                        ),
                    ],
                  ),
                ],
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StoreOrderHistoryStatusBadge extends StatelessWidget {
  const StoreOrderHistoryStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, IconData icon, String label) = switch (status.toUpperCase()) {
      'PENDING' => (const Color(0xFFE8357D), LucideIcons.clock3, 'Jarayonda'),
      'PAID' => (const Color(0xFF25B34B), LucideIcons.check, "To'langan"),
      'SHIPPED' => (const Color(0xFF2563EB), LucideIcons.truck, 'Yuborilgan'),
      'DELIVERED' => (const Color(0xFF16A34A), LucideIcons.checkCheck, 'Topshirildi'),
      'CANCELLED' || 'REFUNDED' => (const Color(0xFFEF4444), LucideIcons.x, 'Bekor qilingan'),
      _ => (context.appColors.grey, LucideIcons.circleDot, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyXSmallRegular.copyWith(color: AppColors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.appColors.stroke.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: context.appColors.grey),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyXSmallRegular.copyWith(
              color: context.appColors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
