import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class TasksScreenSkeleton extends StatelessWidget {
  const TasksScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
        children: [
          Container(
            height: 88,
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusXl,
            ),
          ),
          const SizedBox(height: 26),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: AppRadius.radiusSm,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Container(
                height: index == 1 ? 100 : 80,
                decoration: BoxDecoration(
                  color: context.appColors.onContainer,
                  borderRadius: AppRadius.radiusXl,
                  border: Border.all(color: context.appColors.stroke),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
