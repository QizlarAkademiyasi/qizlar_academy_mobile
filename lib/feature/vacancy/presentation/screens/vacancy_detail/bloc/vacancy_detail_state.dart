part of 'vacancy_detail_bloc.dart';

enum VacancyDetailStatus { initial, loading, success, failure }

class VacancyDetailState extends Equatable {
  const VacancyDetailState({
    this.status = VacancyDetailStatus.initial,
    this.detail,
    this.message,
  });

  final VacancyDetailStatus status;
  final VacancyDetailModel? detail;
  final String? message;

  VacancyDetailState copyWith({
    VacancyDetailStatus? status,
    VacancyDetailModel? detail,
    String? message,
    bool clearDetail = false,
    bool clearMessage = false,
  }) {
    return VacancyDetailState(
      status: status ?? this.status,
      detail: clearDetail ? null : (detail ?? this.detail),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, detail, message];
}
