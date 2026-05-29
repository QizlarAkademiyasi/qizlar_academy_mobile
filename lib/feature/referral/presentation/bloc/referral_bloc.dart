import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_code_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_page_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/repository/referral_repository.dart';

part 'referral_event.dart';
part 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  ReferralBloc(this._repository) : super(const ReferralState()) {
    on<ReferralStarted>(_onStarted);
    on<ReferralRetryRequested>(_onRetryRequested);
  }

  final ReferralRepository _repository;

  static const int _pageSize = 20;

  Future<void> _onStarted(
    ReferralStarted event,
    Emitter<ReferralState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRetryRequested(
    ReferralRetryRequested event,
    Emitter<ReferralState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<ReferralState> emit) async {
    emit(state.copyWith(status: ReferralStatus.loading, clearMessage: true));
    try {
      final responses = await Future.wait<dynamic>([
        _repository.fetchMyReferralCode(),
        _repository.fetchLeaderboard(pageNumber: 1, pageSize: _pageSize),
      ]);
      final code = responses[0] as ReferralCodeModel;
      final leaderboard = responses[1] as ReferralLeaderboardPageModel;
      final hasCode = code.referralCode.trim().isNotEmpty;
      final hasLink = code.referralLink.trim().isNotEmpty;
      emit(
        state.copyWith(
          status: hasCode && hasLink
              ? ReferralStatus.success
              : ReferralStatus.failure,
          code: code,
          leaderboard: leaderboard.items,
          currentUser: leaderboard.currentUser,
          pageNumber: leaderboard.pagination.pageNumber,
          pageSize: leaderboard.pagination.pageSize,
          totalCount: leaderboard.pagination.count,
          pageCount: leaderboard.pagination.pageCount,
          message: hasCode && hasLink
              ? null
              : "Referral ma'lumotlari topilmadi",
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'ReferralBloc: load failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: ReferralStatus.failure,
          message: "Referral bo'limini yuklashda xatolik",
        ),
      );
    }
  }
}
