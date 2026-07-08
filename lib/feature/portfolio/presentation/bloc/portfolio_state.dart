part of 'portfolio_bloc.dart';

enum PortfolioStatus { initial, loading, failure, success }

enum PortfolioFeedTab { all, mine }

class PortfolioState extends Equatable {
  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.tab = PortfolioFeedTab.all,
    this.items = const [],
    this.cursor = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.authRequired = false,
    this.deletedPostId,
    this.message,
    this.isGuest = true,
    required this.seed,
  });

  final PortfolioStatus status;
  final PortfolioFeedTab tab;
  final List<PortfolioPostModel> items;
  final int cursor;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final bool authRequired;
  final String? deletedPostId;
  final String? message;
  final bool isGuest;
  final String seed;

  PortfolioState copyWith({
    PortfolioStatus? status,
    PortfolioFeedTab? tab,
    List<PortfolioPostModel>? items,
    int? cursor,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    bool? authRequired,
    String? deletedPostId,
    bool clearDeletedPostId = false,
    String? message,
    bool clearMessage = false,
    bool? isGuest,
    String? seed,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      tab: tab ?? this.tab,
      items: items ?? this.items,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      authRequired: authRequired ?? this.authRequired,
      deletedPostId: clearDeletedPostId
          ? null
          : (deletedPostId ?? this.deletedPostId),
      message: clearMessage ? null : (message ?? this.message),
      isGuest: isGuest ?? this.isGuest,
      seed: seed ?? this.seed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tab,
    items,
    cursor,
    hasMore,
    isLoadingMore,
    loadMoreFailed,
    authRequired,
    deletedPostId,
    message,
    isGuest,
    seed,
  ];
}
