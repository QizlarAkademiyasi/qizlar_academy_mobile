part of 'referral_bloc.dart';

enum ReferralStatus { initial, loading, success, failure }

class ReferralState extends Equatable {
  const ReferralState({
    this.status = ReferralStatus.initial,
    this.code,
    this.leaderboard = const [],
    this.currentUser,
    this.pageNumber = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.pageCount = 1,
    this.message,
  });

  final ReferralStatus status;
  final ReferralCodeModel? code;
  final List<ReferralLeaderboardUserModel> leaderboard;
  final ReferralLeaderboardUserModel? currentUser;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int pageCount;
  final String? message;

  ReferralState copyWith({
    ReferralStatus? status,
    ReferralCodeModel? code,
    List<ReferralLeaderboardUserModel>? leaderboard,
    ReferralLeaderboardUserModel? currentUser,
    bool clearCurrentUser = false,
    int? pageNumber,
    int? pageSize,
    int? totalCount,
    int? pageCount,
    String? message,
    bool clearMessage = false,
  }) {
    return ReferralState(
      status: status ?? this.status,
      code: code ?? this.code,
      leaderboard: leaderboard ?? this.leaderboard,
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      pageCount: pageCount ?? this.pageCount,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    code,
    leaderboard,
    currentUser,
    pageNumber,
    pageSize,
    totalCount,
    pageCount,
    message,
  ];
}
