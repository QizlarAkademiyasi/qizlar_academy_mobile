part of 'leaderboard_bloc.dart';

enum LeaderboardStatus { initial, loading, success, failure }

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.courseOptions = const [],
    this.selectedCourseId,
    this.timeframe = LeaderboardTimeframe.overall,
    this.topThree = const [],
    this.fullList = const [],
    this.leaderboardCache = const {},
    this.message,
  });

  final LeaderboardStatus status;
  final List<LeaderboardCourseOptionModel> courseOptions;
  final String? selectedCourseId;
  final LeaderboardTimeframe timeframe;
  final List<LeaderboardUserModel> topThree;
  final List<LeaderboardUserModel> fullList;
  final Map<String, List<LeaderboardUserModel>> leaderboardCache;
  final String? message;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<LeaderboardCourseOptionModel>? courseOptions,
    String? selectedCourseId,
    LeaderboardTimeframe? timeframe,
    List<LeaderboardUserModel>? topThree,
    List<LeaderboardUserModel>? fullList,
    Map<String, List<LeaderboardUserModel>>? leaderboardCache,
    String? message,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      courseOptions: courseOptions ?? this.courseOptions,
      selectedCourseId: selectedCourseId ?? this.selectedCourseId,
      timeframe: timeframe ?? this.timeframe,
      topThree: topThree ?? this.topThree,
      fullList: fullList ?? this.fullList,
      leaderboardCache: leaderboardCache ?? this.leaderboardCache,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        courseOptions,
        selectedCourseId,
        timeframe,
        topThree,
        fullList,
        leaderboardCache,
        message,
      ];
}
