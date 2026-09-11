part of 'portfolio_stories_bloc.dart';

enum PortfolioStoriesStatus { initial, loading, success, failure }

class PortfolioStoriesState extends Equatable {
  const PortfolioStoriesState({
    this.status = PortfolioStoriesStatus.initial,
    this.items = const [],
    this.viewedIds = const {},
  });
  final PortfolioStoriesStatus status;
  final List<StoryModel> items;
  final Set<String> viewedIds;
  PortfolioStoriesState copyWith({
    PortfolioStoriesStatus? status,
    List<StoryModel>? items,
    Set<String>? viewedIds,
  }) => PortfolioStoriesState(
    status: status ?? this.status,
    items: items ?? this.items,
    viewedIds: viewedIds ?? this.viewedIds,
  );
  @override
  List<Object?> get props => [status, items, viewedIds];
}
