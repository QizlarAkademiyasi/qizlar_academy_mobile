part of 'vacancy_detail_bloc.dart';

sealed class VacancyDetailEvent extends Equatable {
  const VacancyDetailEvent();

  @override
  List<Object?> get props => [];
}

final class VacancyDetailStarted extends VacancyDetailEvent {
  const VacancyDetailStarted(this.vacancyId);

  final String vacancyId;

  @override
  List<Object?> get props => [vacancyId];
}
