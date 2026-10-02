part of 'daily_coin_bloc.dart';

sealed class DailyCoinEvent extends Equatable {
  const DailyCoinEvent();
}

class DailyCoinStarted extends DailyCoinEvent {
  const DailyCoinStarted();

  @override
  List<Object?> get props => [];
}

class DailyCoinSeeded extends DailyCoinEvent {
  const DailyCoinSeeded(this.streak);

  final DailyStreakModel streak;

  @override
  List<Object?> get props => [streak];
}

class DailyCoinRefreshed extends DailyCoinEvent {
  const DailyCoinRefreshed();

  @override
  List<Object?> get props => [];
}

class DailyCoinClaimPressed extends DailyCoinEvent {
  const DailyCoinClaimPressed();

  @override
  List<Object?> get props => [];
}
