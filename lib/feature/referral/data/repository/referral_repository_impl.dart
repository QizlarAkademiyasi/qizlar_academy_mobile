import 'package:qizlar_academy_mobile/feature/referral/data/datasource/referral_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/referral/data/datasource/referral_local_datasource.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_code_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_page_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/repository/referral_repository.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  const ReferralRepositoryImpl(this._local, this._remote);

  final ReferralLocalDatasource _local;
  final ReferralRemoteDatasource _remote;

  @override
  String? readPendingCode() => _local.readPendingCode();

  @override
  Future<void> savePendingCode(String code) => _local.savePendingCode(code);

  @override
  Future<void> clearPendingCode() => _local.clearPendingCode();

  @override
  Future<void> useReferralCode({required String code}) {
    return _remote.useReferralCode(code: code);
  }

  @override
  Future<ReferralCodeModel> fetchMyReferralCode() {
    return _remote.fetchMyReferralCode();
  }

  @override
  Future<ReferralLeaderboardPageModel> fetchLeaderboard({
    required int pageNumber,
    required int pageSize,
  }) {
    return _remote.fetchLeaderboard(pageNumber: pageNumber, pageSize: pageSize);
  }
}
