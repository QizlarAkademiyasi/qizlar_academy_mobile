part of 'portfolio_detail_bloc.dart';

sealed class PortfolioDetailEvent extends Equatable {
  const PortfolioDetailEvent();

  @override
  List<Object?> get props => [];
}

final class PortfolioDetailStarted extends PortfolioDetailEvent {
  const PortfolioDetailStarted(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PortfolioDetailRetryRequested extends PortfolioDetailEvent {
  const PortfolioDetailRetryRequested();
}

final class PortfolioDetailLikeRequested extends PortfolioDetailEvent {
  const PortfolioDetailLikeRequested();
}

final class PortfolioDetailDeleteRequested extends PortfolioDetailEvent {
  const PortfolioDetailDeleteRequested();
}

final class PortfolioDetailCommentAdded extends PortfolioDetailEvent {
  const PortfolioDetailCommentAdded();
}

final class PortfolioDetailAuthRequiredConsumed extends PortfolioDetailEvent {
  const PortfolioDetailAuthRequiredConsumed();
}
