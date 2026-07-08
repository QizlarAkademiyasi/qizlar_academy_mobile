import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comment_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

part 'portfolio_comments_event.dart';
part 'portfolio_comments_state.dart';

class PortfolioCommentsBloc
    extends Bloc<PortfolioCommentsEvent, PortfolioCommentsState> {
  PortfolioCommentsBloc(this._repository)
    : super(const PortfolioCommentsState()) {
    on<PortfolioCommentsStarted>(_onStarted);
    on<PortfolioCommentsRetryRequested>(_onRetryRequested);
    on<PortfolioCommentsLoadMoreRequested>(_onLoadMoreRequested);
    on<PortfolioCommentSubmitted>(_onSubmitted);
    on<PortfolioRepliesRequested>(_onRepliesRequested);
    on<PortfolioCommentsAuthRequiredConsumed>(_onAuthRequiredConsumed);
  }

  final PortfolioRepository _repository;
  static const int _pageSize = 10;

  Future<void> _onStarted(
    PortfolioCommentsStarted event,
    Emitter<PortfolioCommentsState> emit,
  ) async {
    emit(state.copyWith(postId: event.postId));
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(
    PortfolioCommentsRetryRequested event,
    Emitter<PortfolioCommentsState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<PortfolioCommentsState> emit) async {
    emit(
      state.copyWith(
        status: PortfolioCommentsStatus.loading,
        items: const [],
        pageNumber: 1,
        hasMore: false,
        clearMessage: true,
      ),
    );
    try {
      final page = await _repository.fetchComments(
        postId: state.postId,
        pageNumber: 1,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          status: PortfolioCommentsStatus.success,
          items: page.items,
          pageNumber: page.pageNumber,
          hasMore: page.hasNextPage,
        ),
      );
      for (final comment in page.items) {
        add(PortfolioRepliesRequested(comment.id, forceRefresh: true));
      }
    } catch (e, st) {
      AppLogger.e(
        'PortfolioCommentsBloc: first page failed',
        error: e,
        stackTrace: st,
      );
      emit(state.copyWith(status: PortfolioCommentsStatus.failure));
    }
  }

  Future<void> _onLoadMoreRequested(
    PortfolioCommentsLoadMoreRequested event,
    Emitter<PortfolioCommentsState> emit,
  ) async {
    if (state.status != PortfolioCommentsStatus.success ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final page = await _repository.fetchComments(
        postId: state.postId,
        pageNumber: state.pageNumber + 1,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          items: List<PortfolioCommentModel>.from(state.items)
            ..addAll(page.items),
          pageNumber: page.pageNumber,
          hasMore: page.hasNextPage,
          isLoadingMore: false,
        ),
      );
      for (final comment in page.items) {
        add(PortfolioRepliesRequested(comment.id, forceRefresh: true));
      }
    } catch (e, st) {
      AppLogger.e(
        'PortfolioCommentsBloc: load more failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          isLoadingMore: false,
          message: 'Izohlarni yuklashda xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    PortfolioCommentSubmitted event,
    Emitter<PortfolioCommentsState> emit,
  ) async {
    if (_repository.isGuest) {
      emit(state.copyWith(authRequired: true));
      return;
    }
    final content = event.content.trim();
    if (content.isEmpty) return;
    emit(
      state.copyWith(isSubmitting: true, submitted: false, clearMessage: true),
    );
    try {
      await _repository.addComment(
        postId: state.postId,
        content: content,
        parentId: event.parentId,
      );
      emit(state.copyWith(isSubmitting: false, submitted: true));
      await _loadFirstPage(emit);
      if (event.parentId != null) {
        add(PortfolioRepliesRequested(event.parentId!, forceRefresh: true));
      }
    } catch (e, st) {
      AppLogger.e(
        'PortfolioCommentsBloc: submit failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          message: 'Izoh yuborishda xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onRepliesRequested(
    PortfolioRepliesRequested event,
    Emitter<PortfolioCommentsState> emit,
  ) async {
    final currentPage = event.forceRefresh
        ? 0
        : (state.replyPageByCommentId[event.commentId] ?? 0);
    final currentHasMore =
        state.replyHasMoreByCommentId[event.commentId] ?? true;
    if (!event.forceRefresh && currentPage > 0 && !currentHasMore) return;
    emit(state.copyWith(replyLoadingCommentId: event.commentId));
    try {
      final page = await _repository.fetchReplies(
        postId: state.postId,
        commentId: event.commentId,
        pageNumber: currentPage + 1,
        pageSize: _pageSize,
      );
      final replies = event.forceRefresh
          ? <PortfolioCommentModel>[]
          : List<PortfolioCommentModel>.from(
              state.repliesByCommentId[event.commentId] ?? const [],
            );
      replies.addAll(page.items);
      final nextReplies = Map<String, List<PortfolioCommentModel>>.from(
        state.repliesByCommentId,
      )..[event.commentId] = replies;
      final nextPages = Map<String, int>.from(state.replyPageByCommentId)
        ..[event.commentId] = page.pageNumber;
      final nextHasMore = Map<String, bool>.from(state.replyHasMoreByCommentId)
        ..[event.commentId] = page.hasNextPage;
      emit(
        state.copyWith(
          repliesByCommentId: nextReplies,
          replyPageByCommentId: nextPages,
          replyHasMoreByCommentId: nextHasMore,
          clearReplyLoadingCommentId: true,
        ),
      );
    } catch (e, st) {
      AppLogger.e(
        'PortfolioCommentsBloc: replies failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          clearReplyLoadingCommentId: true,
          message: 'Javoblarni yuklashda xatolik yuz berdi',
        ),
      );
    }
  }

  void _onAuthRequiredConsumed(
    PortfolioCommentsAuthRequiredConsumed event,
    Emitter<PortfolioCommentsState> emit,
  ) {
    emit(state.copyWith(authRequired: false));
  }
}
