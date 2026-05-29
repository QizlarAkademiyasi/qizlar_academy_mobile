import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/bloc/referral_bloc.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/components/referral_leaderboard_item.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/components/referral_podium.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/components/referral_screen_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/components/referral_summary_card.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/screens/referral_screen_mixin.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ReferralBloc>()..add(const ReferralStarted()), child: const _ReferralView());
  }
}

class _ReferralView extends StatefulWidget {
  const _ReferralView();

  @override
  State<_ReferralView> createState() => _ReferralViewState();
}

class _ReferralViewState extends State<_ReferralView> with ReferralScreenMixin<_ReferralView> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ReferralBloc, ReferralState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: buildTopBar(context)),
                Expanded(
                  child: switch (state.status) {
                    ReferralStatus.initial || ReferralStatus.loading => const ReferralScreenSkeleton(),
                    ReferralStatus.failure => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TgsFailureContent(message: state.message ?? "Referral bo'limini yuklashda xatolik", onRetry: () => onRetryTap(context)),
                      ),
                    ),
                    ReferralStatus.success => _SuccessBody(
                      state: state,
                      bottomInset: bottomInset,
                      onCopyTap: () {
                        unawaited(onCopyLinkTap(context, state.code?.referralLink ?? ''));
                      },
                      onShareTap: () {
                        unawaited(onShareTap(context, state.code?.referralLink ?? ''));
                      },
                      topThree: buildTopThree(state.leaderboard),
                      ratingList: buildRatingList(state.leaderboard),
                    ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.state, required this.bottomInset, required this.onCopyTap, required this.onShareTap, required this.topThree, required this.ratingList});

  final ReferralState state;
  final double bottomInset;
  final VoidCallback onCopyTap;
  final VoidCallback onShareTap;
  final List<ReferralLeaderboardUserModel> topThree;
  final List<ReferralLeaderboardUserModel> ratingList;

  @override
  Widget build(BuildContext context) {
    final code = state.code;
    if (code == null) {
      return Center(
        child: Text("Referral ma'lumoti topilmadi", style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text)),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 24 + bottomInset),
      child: AppStaggeredScrollLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppStaggeredListItem(
              position: 0,
              child: ReferralSummaryCard(code: code, currentUser: state.currentUser, onCopyTap: onCopyTap, onShareTap: onShareTap),
            ),
            const SizedBox(height: 16),
            if (topThree.isNotEmpty) AppStaggeredListItem(position: 1, child: ReferralPodium(items: topThree)),
            const SizedBox(height: 16),
            AppStaggeredListItem(
              position: 2,
              child: Text("To'liq reyting", style: context.textTheme.bodyMediumBold.copyWith(color: context.appColors.text)),
            ),
            const SizedBox(height: 10),
            if (ratingList.isEmpty)
              AppStaggeredListItem(
                position: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TgsEmptyContent(message: 'Hali reyting mavjud emas', subtitle: "Birinchi bo'lib taklif qilib, reytingni boshlab bering", animationSize: 92),
                ),
              )
            else
              ...List.generate(
                ratingList.length,
                (index) => AppStaggeredListItem(
                  position: index + 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ReferralLeaderboardItem(user: ratingList[index]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
