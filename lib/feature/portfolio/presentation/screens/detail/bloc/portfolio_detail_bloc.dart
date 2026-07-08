import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

part 'portfolio_detail_event.dart';
part 'portfolio_detail_state.dart';

class PortfolioDetailBloc
    extends Bloc<PortfolioDetailEvent, PortfolioDetailState> {
  PortfolioDetailBloc(this._repository) : super(const PortfolioDetailState()) {
    on<PortfolioDetailStarted>(_onStarted);
    on<PortfolioDetailRetryRequested>(_onRetryRequested);
    on<PortfolioDetailLikeRequested>(_onLikeRequested);
    on<PortfolioDetailDeleteRequested>(_onDeleteRequested);
    on<PortfolioDetailCommentAdded>(_onCommentAdded);
    on<PortfolioDetailAuthRequiredConsumed>(_onAuthRequiredConsumed);
  }

  void _onCommentAdded(
    PortfolioDetailCommentAdded event,
    Emitter<PortfolioDetailState> emit,
  ) {
    final post = state.post;
    if (post == null) return;
    emit(
      state.copyWith(
        post: post.copyWith(commentsCount: post.commentsCount + 1),
      ),
    );
  }

  final PortfolioRepository _repository;

  Future<void> _onStarted(
    PortfolioDetailStarted event,
    Emitter<PortfolioDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PortfolioDetailStatus.loading,
        postId: event.postId,
        clearMessage: true,
      ),
    );
    await _load(event.postId, emit);
  }

  Future<void> _onRetryRequested(
    PortfolioDetailRetryRequested event,
    Emitter<PortfolioDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: PortfolioDetailStatus.loading, clearMessage: true),
    );
    await _load(state.postId, emit);
  }

  Future<void> _load(String postId, Emitter<PortfolioDetailState> emit) async {
    try {
      final post = await _repository.fetchById(postId);
      emit(
        state.copyWith(
          status: PortfolioDetailStatus.success,
          post: post,
          clearMessage: true,
        ),
      );
    } catch (e, st) {
      AppLogger.e('PortfolioDetailBloc: load failed', error: e, stackTrace: st);
      emit(state.copyWith(status: PortfolioDetailStatus.failure));
    }
  }

  Future<void> _onLikeRequested(
    PortfolioDetailLikeRequested event,
    Emitter<PortfolioDetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;
    if (_repository.isGuest) {
      emit(state.copyWith(authRequired: true));
      return;
    }
    emit(state.copyWith(post: post.toggledLike()));
    try {
      final result = await _repository.like(post.id);
      emit(
        state.copyWith(
          post: state.post?.applyLike(
            isLiked: result.isLiked,
            likesCount: result.likesCount,
          ),
        ),
      );
    } catch (e, st) {
      AppLogger.e('PortfolioDetailBloc: like failed', error: e, stackTrace: st);
      emit(
        state.copyWith(post: post, message: 'Like qilishda xatolik yuz berdi'),
      );
    }
  }

  Future<void> _onDeleteRequested(
    PortfolioDetailDeleteRequested event,
    Emitter<PortfolioDetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;
    if (_repository.isGuest) {
      emit(state.copyWith(authRequired: true));
      return;
    }
    try {
      await _repository.deletePost(post.id);
      emit(state.copyWith(deleted: true));
    } catch (e, st) {
      AppLogger.e(
        'PortfolioDetailBloc: delete failed',
        error: e,
        stackTrace: st,
      );
      emit(state.copyWith(message: 'Portfolio o\'chirishda xatolik yuz berdi'));
    }
  }

  void _onAuthRequiredConsumed(
    PortfolioDetailAuthRequiredConsumed event,
    Emitter<PortfolioDetailState> emit,
  ) {
    emit(state.copyWith(authRequired: false));
  }
}
