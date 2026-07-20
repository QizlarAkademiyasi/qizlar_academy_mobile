import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class TasksPaginationModel extends Equatable {
  const TasksPaginationModel({
    required this.pageNumber,
    required this.pageSize,
    required this.count,
    required this.pageCount,
  });

  final int pageNumber;
  final int pageSize;
  final int count;
  final int pageCount;

  @override
  List<Object?> get props => [pageNumber, pageSize, count, pageCount];
}
