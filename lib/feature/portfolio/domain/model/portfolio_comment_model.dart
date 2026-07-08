import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_author_model.dart';

class PortfolioCommentModel extends Equatable {
  const PortfolioCommentModel({
    required this.id,
    required this.content,
    required this.parentId,
    required this.createdAt,
    required this.author,
  });

  final String id;
  final String content;
  final String? parentId;
  final DateTime createdAt;
  final PortfolioAuthorModel author;

  bool get isReply => parentId != null && parentId!.trim().isNotEmpty;

  @override
  List<Object?> get props => [id, content, parentId, createdAt, author];
}
