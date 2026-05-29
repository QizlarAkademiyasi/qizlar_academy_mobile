import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';

class StoreOrderCard extends StatelessWidget {
  const StoreOrderCard({super.key, required this.order, this.onTap});

  final StoreOrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr = '${order.createdAt.day.toString().padLeft(2, '0')}.${order.createdAt.month.toString().padLeft(2, '0')}.${order.createdAt.year}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: order.productThumbnail.isNotEmpty
                    ? AppCachedNetworkImage(
                        imageUrl: order.productThumbnail,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        fallback: const AppNetworkImageFallbackCourse(),
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        color: context.appColors.stroke,
                        child: Icon(LucideIcons.package2, size: 24, color: context.appColors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productTitle.isNotEmpty ? order.productTitle : 'Buyurtma #${order.id.substring(0, 8)}',
                      style: context.textTheme.bodyMediumBold.copyWith(color: context.appColors.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.circleDot, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text('${order.unitPrice} Tanga', style: context.textTheme.bodySmallSemibold.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StoreOrderStatusBadge(status: order.status),
                        const Spacer(),
                        Text(dateStr, style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreOrderStatusBadge extends StatelessWidget {
  const StoreOrderStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status.toUpperCase()) {
      'PENDING' => (const Color(0xFFFFF3CD), const Color(0xFF856404), 'Kutilmoqda'),
      'PAID' => (const Color(0xFFD4EDDA), const Color(0xFF155724), "To'langan"),
      'SHIPPED' => (const Color(0xFFCCE5FF), const Color(0xFF004085), 'Yuborilgan'),
      'DELIVERED' => (const Color(0xFFD4EDDA), const Color(0xFF155724), 'Yetkazilgan'),
      'CANCELLED' => (const Color(0xFFF8D7DA), const Color(0xFF721C24), 'Bekor qilingan'),
      'REFUNDED' => (const Color(0xFFD1ECF1), const Color(0xFF0C5460), 'Qaytarilgan'),
      _ => (context.appColors.stroke, context.appColors.grey, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: context.textTheme.bodySmallSemibold.copyWith(color: fg, fontSize: 10)),
    );
  }
}
