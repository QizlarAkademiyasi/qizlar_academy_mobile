import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/bloc/referral_bloc.dart';

mixin ReferralScreenMixin<T extends StatefulWidget> on State<T> {
  void onBackTap(BuildContext context) {
    context.pop();
  }

  void onRetryTap(BuildContext context) {
    context.read<ReferralBloc>().add(const ReferralRetryRequested());
  }

  Future<void> onCopyLinkTap(BuildContext context, String link) async {
    if (link.trim().isEmpty) {
      AppToast.warning(context, message: "Referral havola topilmadi");
      return;
    }
    await Clipboard.setData(ClipboardData(text: link));
    if (!context.mounted) return;
    AppToast.success(context, message: 'Havola nusxalandi');
  }

  Future<void> onShareTap(BuildContext context, String link) async {
    if (link.trim().isEmpty) {
      AppToast.warning(context, message: "Referral havola topilmadi");
      return;
    }
    await SharePlus.instance.share(
      ShareParams(text: "Qizlar akademiyasi orqali qo'shiling: $link"),
    );
  }

  List<ReferralLeaderboardUserModel> buildTopThree(
    List<ReferralLeaderboardUserModel> items,
  ) {
    final sorted = List<ReferralLeaderboardUserModel>.from(items)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return sorted.take(3).toList(growable: false);
  }

  List<ReferralLeaderboardUserModel> buildRatingList(
    List<ReferralLeaderboardUserModel> items,
  ) {
    final sorted = List<ReferralLeaderboardUserModel>.from(items)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return sorted;
  }
}
