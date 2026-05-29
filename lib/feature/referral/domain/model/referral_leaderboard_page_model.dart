import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_pagination_model.dart';

class ReferralLeaderboardPageModel extends Equatable {
  const ReferralLeaderboardPageModel({
    required this.items,
    required this.pagination,
    this.currentUser,
  });

  final List<ReferralLeaderboardUserModel> items;
  final ReferralPaginationModel pagination;
  final ReferralLeaderboardUserModel? currentUser;

  @override
  List<Object?> get props => [items, pagination, currentUser];
}
