part of 'daily_coin_bloc.dart';

enum DailyCoinStatus { initial, loading, success, failure, claiming }

class DailyCoinState extends Equatable {
  const DailyCoinState({
    this.status = DailyCoinStatus.initial,
    this.streak,
    this.message,
  });

  final DailyCoinStatus status;
  final DailyStreakModel? streak;
  final String? message;

  DailyCoinState copyWith({
    DailyCoinStatus? status,
    DailyStreakModel? streak,
    String? message,
    bool clearMessage = false,
  }) {
    return DailyCoinState(
      status: status ?? this.status,
      streak: streak ?? this.streak,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, streak, message];
}
