part of 'vacancy_bloc.dart';

sealed class VacancyEvent extends Equatable {
  const VacancyEvent();

  @override
  List<Object?> get props => [];
}

class VacancyStarted extends VacancyEvent {
  const VacancyStarted();
}

class VacancyRetryRequested extends VacancyEvent {
  const VacancyRetryRequested();
}

class VacancyLoadMoreRequested extends VacancyEvent {
  const VacancyLoadMoreRequested();
}

class VacancyLoadMoreFailureConsumed extends VacancyEvent {
  const VacancyLoadMoreFailureConsumed();
}
