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
      final code = await _repository.fetchMyReferralCode();
      final hasCode = code.referralCode.trim().isNotEmpty;
      final hasLink = code.referralLink.trim().isNotEmpty;

      ReferralLeaderboardPageModel? leaderboard;
      if (hasCode && hasLink) {
        try {
          leaderboard = await _repository.fetchLeaderboard(
            pageNumber: 1,
            pageSize: _pageSize,
          );
        } catch (error, stackTrace) {
          AppLogger.w(
            'ReferralBloc: leaderboard load failed',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }

      emit(
        state.copyWith(
          status: hasCode && hasLink
              ? ReferralStatus.success
              : ReferralStatus.failure,
          code: code,
          leaderboard: leaderboard?.items ?? const [],
          currentUser: leaderboard?.currentUser,
          clearCurrentUser: leaderboard == null,
          pageNumber: leaderboard?.pagination.pageNumber ?? 1,
          pageSize: leaderboard?.pagination.pageSize ?? _pageSize,
          totalCount: leaderboard?.pagination.count ?? 0,
          pageCount: leaderboard?.pagination.pageCount ?? 1,
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
