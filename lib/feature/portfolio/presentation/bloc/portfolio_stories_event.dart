part of 'portfolio_stories_bloc.dart';

sealed class PortfolioStoriesEvent extends Equatable {
  const PortfolioStoriesEvent();
  @override
  List<Object?> get props => [];
}

final class PortfolioStoriesStarted extends PortfolioStoriesEvent {
  const PortfolioStoriesStarted();
}

final class PortfolioStoryViewed extends PortfolioStoriesEvent {
  const PortfolioStoryViewed(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
