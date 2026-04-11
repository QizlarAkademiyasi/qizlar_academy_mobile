part of 'vacancy_bloc.dart';

enum VacancyStatus { initial, loading, success, failure }

class VacancyState extends Equatable {
  const VacancyState({
    this.status = VacancyStatus.initial,
    this.items = const [],
    this.pageNumber = 1,
    this.pageCount = 1,
    this.pageSize = 10,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.message,
  });

  final VacancyStatus status;
  final List<VacancyItemModel> items;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? message;

  VacancyState copyWith({
    VacancyStatus? status,
    List<VacancyItemModel>? items,
    int? pageNumber,
    int? pageCount,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? message,
    bool clearMessage = false,
  }) {
    return VacancyState(
      status: status ?? this.status,
      items: items ?? this.items,
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, items, pageNumber, pageCount, pageSize, hasMore, isLoadingMore, loadMoreFailed, message];
}
