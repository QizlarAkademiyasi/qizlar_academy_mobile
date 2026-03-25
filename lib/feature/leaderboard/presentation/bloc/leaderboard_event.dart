part of 'leaderboard_bloc.dart';

sealed class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

final class LeaderboardStarted extends LeaderboardEvent {
  const LeaderboardStarted();
}

final class LeaderboardTimeframeChanged extends LeaderboardEvent {
  const LeaderboardTimeframeChanged({required this.timeframe});

  final LeaderboardTimeframe timeframe;

  @override
  List<Object?> get props => [timeframe];
}

final class LeaderboardCourseSelected extends LeaderboardEvent {
  const LeaderboardCourseSelected({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}
