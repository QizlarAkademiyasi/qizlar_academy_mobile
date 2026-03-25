import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_segmented_tab_bar.dart';
import 'package:qizlar_academy_mobile/config/enum/courses_tab.dart';

class CourseTabs extends StatefulWidget {
  const CourseTabs({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.lessonsCount,
    required this.reviewsCount,
  });

  final CoursesTab selected;
  final ValueChanged<CoursesTab> onChanged;
  final int lessonsCount;
  final int reviewsCount;

  @override
  State<CourseTabs> createState() => _CourseTabsState();
}

class _CourseTabsState extends State<CourseTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      initialIndex: widget.selected.index,
      length: CoursesTab.values.length,
    );
  }

  @override
  void didUpdateWidget(covariant CourseTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected &&
        _tabController.index != widget.selected.index) {
      _tabController.animateTo(widget.selected.index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Darslar (${widget.lessonsCount})',
      "Ma'lumot",
      'Sharhlar (${widget.reviewsCount})',
    ];
    return AppSegmentedTabBar(
      controller: _tabController,
      tabLabels: labels,
      onTap: (index) => widget.onChanged(CoursesTab.values[index]),
    );
  }
}
