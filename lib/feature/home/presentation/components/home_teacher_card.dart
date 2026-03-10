import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';

class HomeTeacherCard extends StatelessWidget {
  const HomeTeacherCard({super.key, required this.teacher});

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: teacher.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 72,
                height: 72,
                color: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(LucideIcons.user, color: AppColors.primary, size: 32),
              ),
              errorWidget: (context, url, error) => Container(
                width: 72,
                height: 72,
                color: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(LucideIcons.user, color: AppColors.primary, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            teacher.name,
            style: context.textTheme.bodySmallSemibold.copyWith(
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Text(
              teacher.specialty,
              style: context.textTheme.bodyXSmallMedium.copyWith(
                color: AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${teacher.coursesCount} kurs',
            style: context.textTheme.bodyXSmallRegular.copyWith(
              color: AppColors.secondaryGrey,
            ),
          ),
        ],
      ),
    );
  }
}
