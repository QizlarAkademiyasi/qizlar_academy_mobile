part of 'portfolio_comments_bloc.dart';

enum PortfolioCommentsStatus { initial, loading, failure, success }

class PortfolioCommentsState extends Equatable {
  const PortfolioCommentsState({
    this.status = PortfolioCommentsStatus.initial,
    this.postId = '',
    this.items = const [],
    this.pageNumber = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.authRequired = false,
    this.submitted = false,
    this.message,
    this.repliesByCommentId = const {},
    this.replyPageByCommentId = const {},
    this.replyHasMoreByCommentId = const {},
    this.replyLoadingCommentId,
  });

  final PortfolioCommentsStatus status;
  final String postId;
  final List<PortfolioCommentModel> items;
  final int pageNumber;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSubmitting;
  final bool authRequired;
  final bool submitted;
  final String? message;
  final Map<String, List<PortfolioCommentModel>> repliesByCommentId;
  final Map<String, int> replyPageByCommentId;
  final Map<String, bool> replyHasMoreByCommentId;
  final String? replyLoadingCommentId;

  PortfolioCommentsState copyWith({
    PortfolioCommentsStatus? status,
    String? postId,
    List<PortfolioCommentModel>? items,
    int? pageNumber,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSubmitting,
    bool? authRequired,
    bool? submitted,
    String? message,
    bool clearMessage = false,
    Map<String, List<PortfolioCommentModel>>? repliesByCommentId,
    Map<String, int>? replyPageByCommentId,
    Map<String, bool>? replyHasMoreByCommentId,
    String? replyLoadingCommentId,
    bool clearReplyLoadingCommentId = false,
  }) {
    return PortfolioCommentsState(
      status: status ?? this.status,
      postId: postId ?? this.postId,
      items: items ?? this.items,
      pageNumber: pageNumber ?? this.pageNumber,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      authRequired: authRequired ?? this.authRequired,
      submitted: submitted ?? this.submitted,
      message: clearMessage ? null : (message ?? this.message),
      repliesByCommentId: repliesByCommentId ?? this.repliesByCommentId,
      replyPageByCommentId: replyPageByCommentId ?? this.replyPageByCommentId,
      replyHasMoreByCommentId:
          replyHasMoreByCommentId ?? this.replyHasMoreByCommentId,
      replyLoadingCommentId: clearReplyLoadingCommentId
          ? null
          : (replyLoadingCommentId ?? this.replyLoadingCommentId),
    );
  }

  @override
  List<Object?> get props => [
    status,
    postId,
    items,
    pageNumber,
    hasMore,
    isLoadingMore,
    isSubmitting,
    authRequired,
    submitted,
    message,
    repliesByCommentId,
    replyPageByCommentId,
    replyHasMoreByCommentId,
    replyLoadingCommentId,
  ];
}
