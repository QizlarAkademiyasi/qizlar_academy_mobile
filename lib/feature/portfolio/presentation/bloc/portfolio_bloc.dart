import 'dart:math';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc(this._repository)
    : super(PortfolioState(seed: _newSeed(), isGuest: _repository.isGuest)) {
    on<PortfolioStarted>(_onStarted);
    on<PortfolioRetryRequested>(_onRetryRequested);
    on<PortfolioTabChanged>(_onTabChanged);
    on<PortfolioLoadMoreRequested>(_onLoadMoreRequested);
    on<PortfolioLoadMoreFailureConsumed>(_onLoadMoreFailureConsumed);
    on<PortfolioLikeRequested>(_onLikeRequested);
    on<PortfolioDeleteRequested>(_onDeleteRequested);
    on<PortfolioPostRemovedLocally>(_onPostRemovedLocally);
    on<PortfolioCommentAdded>(_onCommentAdded);
    on<PortfolioAuthRequiredConsumed>(_onAuthRequiredConsumed);
  }

  void _onPostRemovedLocally(
    PortfolioPostRemovedLocally event,
    Emitter<PortfolioState> emit,
  ) {
    emit(
      state.copyWith(
        items: state.items
            .where((item) => item.id != event.postId)
            .toList(growable: false),
        deletedPostId: event.postId,
      ),
    );
  }

  void _onCommentAdded(
    PortfolioCommentAdded event,
    Emitter<PortfolioState> emit,
  ) {
    final next = List<PortfolioPostModel>.from(state.items);
    final index = next.indexWhere((item) => item.id == event.postId);
    if (index == -1) return;
    next[index] = next[index].copyWith(
      commentsCount: next[index].commentsCount + 1,
    );
    emit(state.copyWith(items: next));
  }

  final PortfolioRepository _repository;

  static const int _pageSize = 20;

  static String _newSeed() {
    final random = Random.secure();
    int nextHex(int length) {
      final buffer = StringBuffer();
      for (var i = 0; i < length; i++) {
        buffer.write(random.nextInt(16).toRadixString(16));
      }
      return int.parse(buffer.toString(), radix: 16);
    }

    final part1 = nextHex(8).toRadixString(16).padLeft(8, '0');
    final part2 = nextHex(4).toRadixString(16).padLeft(4, '0');
    final part3 = (0x4000 | nextHex(3)).toRadixString(16).padLeft(4, '0');
    final part4 = (0x8000 | nextHex(3)).toRadixString(16).padLeft(4, '0');
    final part5 =
        '${nextHex(6).toRadixString(16).padLeft(6, '0')}${nextHex(6).toRadixString(16).padLeft(6, '0')}';
    return '$part1-$part2-$part3-$part4-$part5';
  }

  Future<void> _onStarted(
    PortfolioStarted event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(isGuest: _repository.isGuest));
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(
    PortfolioRetryRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onTabChanged(
    PortfolioTabChanged event,
    Emitter<PortfolioState> emit,
  ) async {
    if (event.tab == state.tab) return;
    if (event.tab == PortfolioFeedTab.mine && _repository.isGuest) {
      emit(state.copyWith(authRequired: true));
      return;
    }
    emit(state.copyWith(tab: event.tab, seed: _newSeed()));
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<PortfolioState> emit) async {
    emit(
      state.copyWith(
        status: PortfolioStatus.loading,
        items: const [],
        cursor: 0,
        hasMore: false,
        isLoadingMore: false,
        loadMoreFailed: false,
        clearMessage: true,
      ),
    );
    try {
      final page = await _fetchPage(cursor: 0);
      emit(
        state.copyWith(
          status: PortfolioStatus.success,
          items: page.items,
          cursor: page.nextCursor,
          hasMore: page.hasMore,
          clearMessage: true,
        ),
      );
    } catch (e, st) {
      AppLogger.e('PortfolioBloc: first page failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          status: PortfolioStatus.failure,
          items: const [],
          hasMore: false,
        ),
      );
    }
  }

  Future<void> _onLoadMoreRequested(
    PortfolioLoadMoreRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state.status != PortfolioStatus.success ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));
    try {
      final page = await _fetchPage(cursor: state.cursor);
      emit(
        state.copyWith(
          items: List<PortfolioPostModel>.from(state.items)..addAll(page.items),
          cursor: page.nextCursor,
          hasMore: page.hasMore,
          isLoadingMore: false,
          loadMoreFailed: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('PortfolioBloc: load more failed', error: e, stackTrace: st);
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  Future<void> _onLikeRequested(
    PortfolioLikeRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    if (_repository.isGuest) {
      emit(state.copyWith(authRequired: true));
      return;
    }
    final index = state.items.indexWhere((item) => item.id == event.postId);
    if (index == -1) return;
    final previous = state.items[index];
    final optimisticItems = List<PortfolioPostModel>.from(state.items);
    optimisticItems[index] = previous.toggledLike();
    emit(state.copyWith(items: optimisticItems));
    try {
      final result = await _repository.like(event.postId);
      final synced = List<PortfolioPostModel>.from(state.items);
      final syncIndex = synced.indexWhere((item) => item.id == event.postId);
      if (syncIndex != -1) {
        synced[syncIndex] = synced[syncIndex].applyLike(
          isLiked: result.isLiked,
          likesCount: result.likesCount,
        );
      }
      emit(state.copyWith(items: synced));
    } catch (e, st) {
      AppLogger.e('PortfolioBloc: like failed', error: e, stackTrace: st);
      final rolledBack = List<PortfolioPostModel>.from(state.items);
      final rollbackIndex = rolledBack.indexWhere(
        (item) => item.id == event.postId,
      );
      if (rollbackIndex != -1) {
        rolledBack[rollbackIndex] = previous;
      }
      emit(
        state.copyWith(
          items: rolledBack,
          message: 'Like qilishda xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    PortfolioDeleteRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    if (_repository.isGuest) {
      emit(state.copyWith(authRequired: true));
      return;
    }
    final previousItems = state.items;
    final nextItems = state.items
        .where((item) => item.id != event.postId)
        .toList(growable: false);
    emit(state.copyWith(items: nextItems));
    try {
      await _repository.deletePost(event.postId);
      emit(state.copyWith(deletedPostId: event.postId));
    } catch (e, st) {
      AppLogger.e('PortfolioBloc: delete failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          items: previousItems,
          message: 'Portfolio o\'chirishda xatolik yuz berdi',
        ),
      );
    }
  }

  void _onLoadMoreFailureConsumed(
    PortfolioLoadMoreFailureConsumed event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(loadMoreFailed: false));
  }

  void _onAuthRequiredConsumed(
    PortfolioAuthRequiredConsumed event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(authRequired: false));
  }

  Future<dynamic> _fetchPage({required int cursor}) {
    if (state.tab == PortfolioFeedTab.mine) {
      return _repository.fetchUserFeed(
        seed: state.seed,
        cursor: cursor,
        pageSize: _pageSize,
      );
    }
    return _repository.isGuest
        ? _repository.fetchPublicFeed(
            seed: state.seed,
            cursor: cursor,
            pageSize: _pageSize,
          )
        : _repository.fetchUserFeed(
            seed: state.seed,
            cursor: cursor,
            pageSize: _pageSize,
          );
  }
}
