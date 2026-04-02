import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Kurs detali: global segmentli tab bar ([AppSegmentedTabBar]).
class CourseTabs extends StatelessWidget {
  const CourseTabs({
    super.key,
    required this.controller,
    required this.lessonsCount,
    required this.reviewsCount,
    this.onTap,
  });

  final TabController controller;
  final int lessonsCount;
  final int reviewsCount;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.courseTabLessons(lessonsCount),
      l10n.courseTabInfo,
      l10n.courseTabReviews(reviewsCount),
    ];
    return AppSegmentedTabBar(controller: controller, tabLabels: labels, onTap: onTap);
  }
}
