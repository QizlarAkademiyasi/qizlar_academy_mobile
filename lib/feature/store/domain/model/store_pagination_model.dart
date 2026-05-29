import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StorePaginationModel extends Equatable {
  const StorePaginationModel({
    required this.totalCount,
    required this.pageCount,
    required this.pageNumber,
    required this.pageSize,
  });

  final int totalCount;
  final int pageCount;
  final int pageNumber;
  final int pageSize;

  bool get hasNextPage => pageNumber < pageCount;

  @override
  List<Object?> get props => [totalCount, pageCount, pageNumber, pageSize];
}
