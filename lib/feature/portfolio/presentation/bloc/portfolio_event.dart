part of 'portfolio_bloc.dart';

sealed class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

final class PortfolioStarted extends PortfolioEvent {
  const PortfolioStarted();
}

final class PortfolioRetryRequested extends PortfolioEvent {
  const PortfolioRetryRequested();
}

final class PortfolioTabChanged extends PortfolioEvent {
  const PortfolioTabChanged(this.tab);

  final PortfolioFeedTab tab;

  @override
  List<Object?> get props => [tab];
}

final class PortfolioLoadMoreRequested extends PortfolioEvent {
  const PortfolioLoadMoreRequested();
}

final class PortfolioLoadMoreFailureConsumed extends PortfolioEvent {
  const PortfolioLoadMoreFailureConsumed();
}

final class PortfolioLikeRequested extends PortfolioEvent {
  const PortfolioLikeRequested(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PortfolioDeleteRequested extends PortfolioEvent {
  const PortfolioDeleteRequested(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PortfolioPostRemovedLocally extends PortfolioEvent {
  const PortfolioPostRemovedLocally(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PortfolioCommentAdded extends PortfolioEvent {
  const PortfolioCommentAdded(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PortfolioAuthRequiredConsumed extends PortfolioEvent {
  const PortfolioAuthRequiredConsumed();
}
