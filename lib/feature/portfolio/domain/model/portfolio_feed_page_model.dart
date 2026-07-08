import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';

class PortfolioFeedPageModel extends Equatable {
  const PortfolioFeedPageModel({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  final List<PortfolioPostModel> items;
  final int nextCursor;
  final bool hasMore;

  @override
  List<Object?> get props => [items, nextCursor, hasMore];
}
