import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreDetailInfoCard extends StatelessWidget {
  const StoreDetailInfoCard({super.key, required this.description, this.features = const []});

  final String description;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return AppLiquidStretch(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.info, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Mahsulot haqida', style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text)),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
            if (features.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: features.map((f) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circleDot, size: 12, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Flexible(child: Text(f, style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.grey))),
                    ],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
