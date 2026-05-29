import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/bloc/daily_coin_bloc.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/components/daily_coin_streak_row.dart';

class DailyCoinSheetContent extends StatelessWidget {
  const DailyCoinSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyCoinBloc, DailyCoinState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final streak = state.streak;

        if (state.status == DailyCoinStatus.failure && streak == null) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TgsFailureContent(
                  message: state.message == 'claim_failed' ? l10n.dailyCoinClaimError : l10n.dailyCoinLoadError,
                  onRetry: () => context.read<DailyCoinBloc>().add(const DailyCoinRefreshed()),
                ),
              ],
            ),
          );
        }

        final count = streak?.streakCount ?? 0;
        final displayCount = count.clamp(1, 10);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.appColors.iconSecondary.withValues(alpha: 0.35)),
              child: Center(
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.appColors.onContainer.withValues(alpha: 0.35)),
                  child: Icon(LucideIcons.circleStar, size: 38, color: AppColors.otherOrange),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.dailyCoinStreakTitle(displayCount),
              style: context.textTheme.heading6.copyWith(color: context.appColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dailyCoinStreakSubtitle,
              style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.text.withValues(alpha: 0.82)),
              textAlign: TextAlign.center,
            ),
            // if (streak?.isClaimed != true && streak != null) ...[
            //   const SizedBox(height: 10),
            //   Text(
            //     l10n.dailyCoinRewardToday(displayCount),
            //     style: context.textTheme.bodySmallBold.copyWith(color: context.appColors.primary),
            //     textAlign: TextAlign.center,
            //   ),
            // ],
            const SizedBox(height: 22),
            if (state.status == DailyCoinStatus.loading && streak == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Skeletonizer(child: Bone.square(size: 72)),
              )
            else ...[
              DailyCoinStreakRow(streakCount: displayCount),
              const SizedBox(height: 8),
              PrimaryButton.elevated(
                applyTabletMaxWidth: false,
                shape: AppPrimaryButtonShape.roundedRectangle,
                label: streak?.isClaimed == true ? l10n.dailyCoinClaimedButton : l10n.dailyCoinClaimButton,
                isEnabled: streak?.isClaimed != true,
                isLoading: state.status == DailyCoinStatus.claiming,
                onPressed: streak?.isClaimed == true ? null : () => context.read<DailyCoinBloc>().add(const DailyCoinClaimPressed()),
              ),
            ],
          ],
        );
      },
    );
  }
}
