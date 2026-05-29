part of 'my_activity_bloc.dart';

sealed class MyActivityEvent extends Equatable {
  const MyActivityEvent();
}

class MyActivityStarted extends MyActivityEvent {
  const MyActivityStarted();

  @override
  List<Object?> get props => [];
}

class MyActivityRetryRequested extends MyActivityEvent {
  const MyActivityRetryRequested();

  @override
  List<Object?> get props => [];
}

class MyActivityScopeChanged extends MyActivityEvent {
  const MyActivityScopeChanged(this.scope);

  final MyActivityStatsScope scope;

  @override
  List<Object?> get props => [scope];
}
