import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_category_dropdown.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_list_item.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_promotion_banner.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_top_performers_card.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/components/leaderboard_user_details_bottom_sheet.dart';

mixin LeaderboardScreenMixin<T extends StatefulWidget> on State<T> {
  void leaderboardBlocListener(BuildContext context, LeaderboardState state) {}

  void onTimeframeChanged(LeaderboardTimeframe timeframe) {
    context.read<LeaderboardBloc>().add(LeaderboardTimeframeChanged(timeframe: timeframe));
  }

  void onCategoryTap(BuildContext context, {required List<LeaderboardCourseOptionModel> options, required String? selectedId}) {
    if (options.isEmpty) return;
    final bloc = context.read<LeaderboardBloc>();
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    showAppBottomSheet<void>(
      context,
      child: AppBottomSheetContainer(
        title: context.l10n.leaderboardSelectCourse,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColors.onContainer.withValues(alpha: 0.9),
              borderRadius: AppRadius.radiusXl,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.radiusXl,
              child: Stack(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 28),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option.id == selectedId;
                      return ListTile(
                        title: Text(option.name, style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.text)),
                        trailing: isSelected ? Icon(LucideIcons.check, color: context.appColors.primary, size: 18) : null,
                        onTap: () {
                          Navigator.pop(context);
                          bloc.add(LeaderboardCourseSelected(courseId: option.id));
                        },
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 34,
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 0.1),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(borderRadius: AppRadius.radius5xl, color: context.appColors.onContainer),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Icon(LucideIcons.chevronsDown, size: 18, color: context.appColors.grey.withValues(alpha: 0.9)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onStartTap() {
    // Navigatsiya: kurslar yoki asosiy sahifaga. Router orqali.
    Gaimon.light();
  }

  void onLeaderboardUserTap(BuildContext context, LeaderboardUserModel user) {
    showAppBottomSheet<void>(
      context,
      child: LeaderboardUserDetailsBottomSheet(
        user: user,
        courseName:
            context
                .read<LeaderboardBloc>()
                .state
                .courseOptions
                .where((c) => c.id == context.read<LeaderboardBloc>().state.selectedCourseId)
                .map((c) => c.name)
                .cast<String?>()
                .firstWhere((_) => true, orElse: () => null) ??
            context.l10n.leaderboardSelectCourse,
      ),
    );
  }

  Widget buildLeaderboardHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.leaderboardTitle, style: context.textTheme.heading4.copyWith(color: context.appColors.text)),
        const SizedBox(height: 4),
        Text(context.l10n.leaderboardSubtitle, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
      ],
    );
  }

  Widget buildLeaderboardTabs(BuildContext context, {required TabController tabController, required ValueChanged<LeaderboardTimeframe> onChanged}) {
    final l10n = context.l10n;
    return AppSegmentedTabBar(
      controller: tabController,
      tabLabels: [l10n.leaderboardTabOverall, l10n.leaderboardTabWeekly, l10n.leaderboardTabMonthly],
      onTap: (index) => onChanged(LeaderboardTimeframe.values[index]),
    );
  }

  Widget buildLeaderboardCategoryDropdown(BuildContext context, {required String selectedCourseName, required VoidCallback onTap}) {
    return LeaderboardCategoryDropdown(selectedCourseName: selectedCourseName, onTap: onTap);
  }

  Widget buildLeaderboardTopPerformers(BuildContext context, {required List<LeaderboardUserModel> topThree, required ValueChanged<LeaderboardUserModel> onUserTap}) {
    return LeaderboardTopPerformersCard(topThree: topThree, onUserTap: onUserTap);
  }

  Widget buildLeaderboardFullList(BuildContext context, {required List<LeaderboardUserModel> fullList, required ValueChanged<LeaderboardUserModel> onUserTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.leaderboardFullRanking, style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text)),
        const SizedBox(height: 12),
        ...fullList.asMap().entries.map<Widget>(
          (entry) => AppStaggeredListItem(
            position: entry.key,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LeaderboardListItem(user: entry.value, onTap: () => onUserTap(entry.value)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLeaderboardPromotionBanner(BuildContext context, {required VoidCallback onStartTap}) {
    return LeaderboardPromotionBanner(onStartTap: onStartTap);
  }
}
