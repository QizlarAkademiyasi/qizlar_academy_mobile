part of 'my_certificates_bloc.dart';

enum MyCertificatesStatus { initial, loading, success, failure }

class MyCertificatesState extends Equatable {
  const MyCertificatesState({
    this.status = MyCertificatesStatus.initial,
    this.items = const [],
    this.pageNumber = 1,
    this.pageCount = 1,
    this.pageSize = 10,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final MyCertificatesStatus status;
  final List<CertificateItemModel> items;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  MyCertificatesState copyWith({
    MyCertificatesStatus? status,
    List<CertificateItemModel>? items,
    int? pageNumber,
    int? pageCount,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return MyCertificatesState(
      status: status ?? this.status,
      items: items ?? this.items,
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    pageNumber,
    pageCount,
    pageSize,
    hasMore,
    isLoadingMore,
    loadMoreFailed,
  ];
}
