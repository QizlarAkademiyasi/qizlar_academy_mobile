import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeLastLessonCard extends StatelessWidget {
  const HomeLastLessonCard({
    super.key,
    required this.category,
    required this.progress,
    required this.onTap,
    this.isLoading = false,
  });

  final String category;
  final double progress;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () {
        Gaimon.light();
        onTap?.call();
      },
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.radiusXl,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Skeletonizer(
                          enabled: isLoading,
                          child: Text(
                            category,
                            style: context.textTheme.bodyXLargeBold.copyWith(
                              color: AppColors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Skeletonizer(
                        enabled: isLoading,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.arrowUpRight,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      "Oxirgi ko’rilgan dars",
                      style: context.textTheme.bodyXSmallRegular.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),

                  Spacer(),
                  Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      '${(progress * 100).round()}%',
                      style: context.textTheme.heading4.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  const _CircularProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(
        painter: _CircularProgressPainter(progress: progress),
        child: Center(
          child: Icon(LucideIcons.play, color: AppColors.white, size: 18),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final backgroundPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
