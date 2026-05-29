import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/format/coin_compact_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreDetailPurchaseBar extends StatelessWidget {
  const StoreDetailPurchaseBar({
    super.key,
    required this.price,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isSold = false,
  });

  final int price;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.paddingOf(context).bottom + 12),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        border: Border(top: BorderSide(color: context.appColors.stroke)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('HAMYONINGIZGA', style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey, fontSize: 10, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(LucideIcons.circleDot, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(CoinCompactFormat.short(price), style: context.textTheme.bodyXLargeBold.copyWith(color: context.appColors.text)),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppLiquidStretch.compact(
              child: PrimaryButton.elevated(
                label: label,
                onPressed: isSold ? null : onPressed,
                isLoading: isLoading,
                isEnabled: !isSold,
                leading: isSold ? null : Icon(LucideIcons.shoppingCart, color: AppColors.white, size: 18),
                backgroundColor: isSold ? context.appColors.grey : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
