part of 'my_activity_bloc.dart';

enum MyActivityStatus { initial, loading, success, failure }

class MyActivityState extends Equatable {
  const MyActivityState({
    this.status = MyActivityStatus.initial,
    this.selectedScope = MyActivityStatsScope.weekly,
    this.weekly,
    this.monthly,
    this.message,
  });

  final MyActivityStatus status;
  final MyActivityStatsScope selectedScope;
  final ActivityStatsModel? weekly;
  final ActivityStatsModel? monthly;
  final String? message;

  ActivityStatsModel? get activeStats =>
      selectedScope == MyActivityStatsScope.weekly ? weekly : monthly;

  MyActivityState copyWith({
    MyActivityStatus? status,
    MyActivityStatsScope? selectedScope,
    ActivityStatsModel? weekly,
    ActivityStatsModel? monthly,
    String? message,
    bool clearMessage = false,
  }) {
    return MyActivityState(
      status: status ?? this.status,
      selectedScope: selectedScope ?? this.selectedScope,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, selectedScope, weekly, monthly, message];
}
