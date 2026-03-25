import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
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
    context.read<LeaderboardBloc>().add(
      LeaderboardTimeframeChanged(timeframe: timeframe),
    );
  }

  void onCategoryTap(
    BuildContext context, {
    required List<LeaderboardCourseOptionModel> options,
    required String? selectedId,
  }) {
    if (options.isEmpty) return;
    showAppBottomSheet<void>(
      context,
      child: AppBottomSheetContainer(
        title: 'Kursni tanlang',
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.onContainer.withValues(alpha: 0.9),
            borderRadius: AppRadius.radiusXl,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = option.id == selectedId;
              return ListTile(
                title: Text(
                  option.name,
                  style: context.textTheme.bodyMediumSemibold.copyWith(
                    color: context.appColors.text,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        LucideIcons.check,
                        color: context.appColors.primary,
                        size: 18,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  context.read<LeaderboardBloc>().add(
                    LeaderboardCourseSelected(courseId: option.id),
                  );
                },
              );
            }).toList(),
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
      child: LeaderboardUserDetailsBottomSheet(user: user),
    );
  }

  Widget buildLeaderboardHeader(BuildContext context) {
    return Padding(
      padding: AppPadding.paddingHorizontalLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peshqadamlar',
            style: context.textTheme.heading4.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Eng yaxshi o\'quvchilar reytingi',
            style: context.textTheme.bodyMediumRegular.copyWith(
              color: context.appColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeaderboardTabs(
    BuildContext context, {
    required TabController tabController,
    required ValueChanged<LeaderboardTimeframe> onChanged,
  }) {
    return AppSegmentedTabBar(
      controller: tabController,
      tabLabels: const ['Umumiy', 'Haftalik', 'Oylik'],
      onTap: (index) => onChanged(LeaderboardTimeframe.values[index]),
    );
  }

  Widget buildLeaderboardCategoryDropdown(
    BuildContext context, {
    required String selectedCourseName,
    required VoidCallback onTap,
  }) {
    return LeaderboardCategoryDropdown(
      selectedCourseName: selectedCourseName,
      onTap: onTap,
    );
  }

  Widget buildLeaderboardTopPerformers(
    BuildContext context, {
    required List<LeaderboardUserModel> topThree,
    required ValueChanged<LeaderboardUserModel> onUserTap,
  }) {
    return LeaderboardTopPerformersCard(
      topThree: topThree,
      onUserTap: onUserTap,
    );
  }

  Widget buildLeaderboardFullList(
    BuildContext context, {
    required List<LeaderboardUserModel> fullList,
    required ValueChanged<LeaderboardUserModel> onUserTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To\'liq reyting',
          style: context.textTheme.bodyLargeBold.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ...fullList.map<Widget>(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LeaderboardListItem(
              user: user,
              onTap: () => onUserTap(user),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLeaderboardPromotionBanner(
    BuildContext context, {
    required VoidCallback onStartTap,
  }) {
    return LeaderboardPromotionBanner(onStartTap: onStartTap);
  }
}
