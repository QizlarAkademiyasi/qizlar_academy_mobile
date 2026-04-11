part of 'courses_catalog_bloc.dart';

enum CoursesCatalogStatus { initial, loading, success, failure }

class CoursesCatalogState extends Equatable {
  const CoursesCatalogState({
    this.status = CoursesCatalogStatus.initial,
    this.query = '',
    this.overview,
    this.message,
    this.isRefreshing = false,
  });

  final CoursesCatalogStatus status;
  final String query;
  final CoursesCatalogOverviewModel? overview;
  final String? message;

  /// Pastdan tortib yangilash — ro‘yxat yo‘qolmaydi, faqat indikator.
  final bool isRefreshing;

  bool get hasData => overview != null && !overview!.isEmpty;

  CoursesCatalogState copyWith({
    CoursesCatalogStatus? status,
    String? query,
    CoursesCatalogOverviewModel? overview,
    String? message,
    bool clearMessage = false,
    bool? isRefreshing,
  }) {
    return CoursesCatalogState(
      status: status ?? this.status,
      query: query ?? this.query,
      overview: overview ?? this.overview,
      message: clearMessage ? null : (message ?? this.message),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [status, query, overview, message, isRefreshing];
}
