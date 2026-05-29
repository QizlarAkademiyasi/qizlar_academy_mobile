part of 'store_history_bloc.dart';

sealed class StoreHistoryEvent extends Equatable {
  const StoreHistoryEvent();

  @override
  List<Object?> get props => [];
}

class StoreHistoryStarted extends StoreHistoryEvent {
  const StoreHistoryStarted();
}

class StoreHistoryRetryRequested extends StoreHistoryEvent {
  const StoreHistoryRetryRequested();
}

class StoreHistoryLoadMoreRequested extends StoreHistoryEvent {
  const StoreHistoryLoadMoreRequested();
}

class StoreHistoryLoadMoreFailureConsumed extends StoreHistoryEvent {
  const StoreHistoryLoadMoreFailureConsumed();
}
