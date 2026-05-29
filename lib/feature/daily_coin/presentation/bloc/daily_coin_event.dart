part of 'daily_coin_bloc.dart';

sealed class DailyCoinEvent extends Equatable {
  const DailyCoinEvent();
}

class DailyCoinStarted extends DailyCoinEvent {
  const DailyCoinStarted();

  @override
  List<Object?> get props => [];
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
