import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class VacanciesListSkeleton extends StatelessWidget {
  const VacanciesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: const [
          _VacancySkeletonCard(),
          SizedBox(height: 16),
          _VacancySkeletonCard(),
          SizedBox(height: 16),
          _VacancySkeletonCard(),
        ],
      ),
    );
  }
}

class _VacancySkeletonCard extends StatelessWidget {
  const _VacancySkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.radiusMd,
          child: SizedBox(
            width: double.infinity,
            height: 168,
            child: Bone.button(),
          ),
        ),
      ],
    );
  }
}
