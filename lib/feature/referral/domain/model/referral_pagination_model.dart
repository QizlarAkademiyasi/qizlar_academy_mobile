import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class ReferralPaginationModel extends Equatable {
  const ReferralPaginationModel({
    required this.pageNumber,
    required this.pageSize,
    required this.count,
    required this.pageCount,
  });

  final int pageNumber;
  final int pageSize;
  final int count;
  final int pageCount;

  bool get hasNextPage => pageNumber < pageCount;

  @override
  List<Object?> get props => [pageNumber, pageSize, count, pageCount];
}
