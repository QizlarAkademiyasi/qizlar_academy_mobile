import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StorePromoCodeSheet extends StatelessWidget {
  const StorePromoCodeSheet({super.key, required this.promoCode, required this.productTitle});

  final String promoCode;
  final String productTitle;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.gift, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(productTitle, style: context.textTheme.bodyXLargeBold.copyWith(color: context.appColors.text), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.appColors.stroke),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(promoCode, style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text)),
                ),
                AppLiquidStretch.compact(
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: promoCode));
                      AppToast.success(context, message: 'Nusxa olindi');
                    },
                    child: Icon(LucideIcons.copy, size: 20, color: context.appColors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
