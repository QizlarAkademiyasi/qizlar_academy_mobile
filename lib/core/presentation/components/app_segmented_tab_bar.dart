import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Global segmentli tab bar — pill ko‘rinishida, primary indikator.
/// Leaderboard, filtrlarda va boshqa ekranlarda qayta ishlatish uchun.
class AppSegmentedTabBar extends StatelessWidget {
  const AppSegmentedTabBar({super.key, required this.controller, required this.tabLabels, this.onTap});

  final TabController controller;
  final List<String> tabLabels;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius5xl,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: TabBar(
        controller: controller,
        onTap: (index) {
          Gaimon.light();
          onTap?.call(index);
        },
        indicator: BoxDecoration(borderRadius: AppRadius.radius5xl, color: AppColors.primary),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.white,
        splashBorderRadius: AppRadius.radius5xl,
        splashFactory: NoSplash.splashFactory,
        unselectedLabelColor: context.appColors.grey,
        labelStyle: context.textTheme.bodyMediumSemibold,
        unselectedLabelStyle: context.textTheme.bodyMediumRegular,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        tabs: tabLabels.map((label) => Tab(text: label)).toList(),
      ),
    );
  }
}
