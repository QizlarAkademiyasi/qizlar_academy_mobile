import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/repository/my_activity_repository.dart';

/// Faollik ekrani yuklanayotganda — haqiqiy layoutga yaqin tuzilish (chart + Statistikalar).
class ActivityScreenLoadingBody extends StatelessWidget {
  const ActivityScreenLoadingBody({super.key, required this.scope});

  final MyActivityStatsScope scope;

  /// [ActivityWeeklyChartCard] grafik blok balandligi.
  static const double _barsTrackHeight = 148;

  static const List<double> _barFillHeights = [76, 118, 58, 128, 70, 100, 86];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom + 24;

    return Skeletonizer.zone(
      ignoreContainers: true,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 12, 20, bottom),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: context.appColors.stroke),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: scope == MyActivityStatsScope.weekly
                  ? _buildWeeklyChartSkeleton()
                  : const _MonthlyCalendarSkeleton(),
            ),
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Bone.text(words: 1, fontSize: 17),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: List.generate(4, (_) => const ActivityStatTileSkeleton()),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChartSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bone.text(words: 3, fontSize: 12),
        const SizedBox(height: 6),
        Bone.text(words: 2, fontSize: 21),
        const SizedBox(height: 18),
        SizedBox(
          height: _barsTrackHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i != 0) const SizedBox(width: 6),
                Expanded(child: _weekBarStem(_barFillHeights[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Widget _weekBarStem(double fillHeight) {
  final trackReserve = fillHeight.clamp(0.0, 118.0);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Bone(
            width: double.infinity,
            height: trackReserve,
            uniRadius: 999,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Center(child: Bone.text(words: 1, fontSize: 11)),
    ],
  );
}

/// Oy ko‘rinishi kartasi skletoni.
class _MonthlyCalendarSkeleton extends StatelessWidget {
  const _MonthlyCalendarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Bone.iconButton(size: 42),
            const Expanded(
              child: Center(child: Bone.text(words: 2, fontSize: 17)),
            ),
            const Bone.iconButton(size: 42),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(child: Center(child: Bone.text(words: 1, fontSize: 11))),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 35,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, _) {
            return const Center(child: Bone.circle(size: 32));
          },
        ),
      ],
    );
  }
}

/// [ActivityStatGrid] / [_ActivityStatTile] ga mos kartochka skeletlari.
class ActivityStatTileSkeleton extends StatelessWidget {
  const ActivityStatTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.circle(size: 32),
              Spacer(),
              Bone.multiText(lines: 1, fontSize: 16),
              SizedBox(height: 6),
              Bone.multiText(lines: 2, fontSize: 11),
            ],
          ),
        ),
      ),
    );
  }
}
