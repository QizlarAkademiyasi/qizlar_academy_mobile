import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CourseSubmitReviewStarPicker extends StatelessWidget {
  const CourseSubmitReviewStarPicker({super.key, required this.rating, required this.onChanged});

  /// 0 — tanlanmagan; 1..5 — butun yulduzlar.
  final double rating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = (index + 1).toDouble();
        final filled = rating + 0.001 >= starValue;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(LucideIcons.star, size: 38, color: filled ? AppColors.primary : context.appColors.stroke),
          ),
        );
      }),
    );
  }
}
