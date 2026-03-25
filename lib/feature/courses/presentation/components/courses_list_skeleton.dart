import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CoursesListSkeleton extends StatelessWidget {
  const CoursesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
        children: [
          _skeletonBox(context, height: 190),
          const SizedBox(height: 16),
          _skeletonBox(context, height: 254),
          const SizedBox(height: 16),
          _skeletonBox(context, height: 254),
        ],
      ),
    );
  }

  Widget _skeletonBox(BuildContext context, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
      ),
    );
  }
}
