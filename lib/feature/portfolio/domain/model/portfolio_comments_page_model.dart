import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comment_model.dart';

class PortfolioCommentsPageModel extends Equatable {
  const PortfolioCommentsPageModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.pageCount,
  });

  final List<PortfolioCommentModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int pageCount;

  bool get hasNextPage => pageNumber < pageCount;

  @override
  List<Object?> get props => [
    items,
    pageNumber,
    pageSize,
    totalCount,
    pageCount,
  ];
}
