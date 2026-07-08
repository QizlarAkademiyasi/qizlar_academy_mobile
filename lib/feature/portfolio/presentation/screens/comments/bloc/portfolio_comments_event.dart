part of 'portfolio_comments_bloc.dart';

sealed class PortfolioCommentsEvent extends Equatable {
  const PortfolioCommentsEvent();

  @override
  List<Object?> get props => [];
}

final class PortfolioCommentsStarted extends PortfolioCommentsEvent {
  const PortfolioCommentsStarted(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PortfolioCommentsRetryRequested extends PortfolioCommentsEvent {
  const PortfolioCommentsRetryRequested();
}

final class PortfolioCommentsLoadMoreRequested extends PortfolioCommentsEvent {
  const PortfolioCommentsLoadMoreRequested();
}

final class PortfolioCommentSubmitted extends PortfolioCommentsEvent {
  const PortfolioCommentSubmitted({required this.content, this.parentId});

  final String content;
  final String? parentId;

  @override
  List<Object?> get props => [content, parentId];
}

final class PortfolioRepliesRequested extends PortfolioCommentsEvent {
  const PortfolioRepliesRequested(this.commentId, {this.forceRefresh = false});

  final String commentId;
  final bool forceRefresh;

  @override
  List<Object?> get props => [commentId, forceRefresh];
}

final class PortfolioCommentsAuthRequiredConsumed
    extends PortfolioCommentsEvent {
  const PortfolioCommentsAuthRequiredConsumed();
}
