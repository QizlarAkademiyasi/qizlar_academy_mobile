import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CourseProgressCard extends StatelessWidget {
  const CourseProgressCard({
    super.key,
    required this.progressLabel,
    required this.progressSeenText,
    required this.progressTotalText,
    required this.progressRatio,
  });

  final String progressLabel;
  final String progressSeenText;
  final String progressTotalText;
  final double progressRatio;

  @override
  Widget build(BuildContext context) {
    final ratio = progressRatio.clamp(0.0, 1.0);

    return Container(
      padding: AppPadding.paddingLg,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Kurs jarayoni',
                style: context.textTheme.bodyLargeBold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              const Spacer(),
              Text(
                progressLabel,
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: context.appColors.stroke,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                progressSeenText,
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: context.appColors.grey,
                ),
              ),
              const Spacer(),
              Text(
                progressTotalText,
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: context.appColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
