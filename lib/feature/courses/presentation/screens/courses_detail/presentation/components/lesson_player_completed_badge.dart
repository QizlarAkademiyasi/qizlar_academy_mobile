import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Dars yakunlanganini ko‘rsatish (matn tugma o‘rniga status chip).
class LessonPlayerCompletedBadge extends StatelessWidget {
  const LessonPlayerCompletedBadge({super.key, required this.label});

  final String label;

  static const Color _success = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _success.withValues(alpha: 0.10),
        borderRadius: AppRadius.radius2xl,
        border: Border.all(color: _success.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.circleCheck, color: _success, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: context.textTheme.bodyMediumSemibold.copyWith(color: _success, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}
