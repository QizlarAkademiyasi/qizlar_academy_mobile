import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_code_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_page_model.dart';

abstract interface class ReferralRepository {
  String? readPendingCode();
  Future<void> savePendingCode(String code);
  Future<void> clearPendingCode();
  Future<void> useReferralCode({required String code});
  Future<ReferralCodeModel> fetchMyReferralCode();
  Future<ReferralLeaderboardPageModel> fetchLeaderboard({
    required int pageNumber,
    required int pageSize,
  });
}
