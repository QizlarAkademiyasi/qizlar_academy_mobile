import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
part 'portfolio_stories_event.dart';
part 'portfolio_stories_state.dart';

class PortfolioStoriesBloc
    extends Bloc<PortfolioStoriesEvent, PortfolioStoriesState> {
  PortfolioStoriesBloc(this.repository) : super(const PortfolioStoriesState()) {
    on<PortfolioStoriesStarted>(_load);
    on<PortfolioStoryViewed>(_view);
  }
  final HomeRepository repository;
  Future<void> _load(
    PortfolioStoriesStarted event,
    Emitter<PortfolioStoriesState> emit,
  ) async {
    if (state.status == PortfolioStoriesStatus.loading) return;
    emit(state.copyWith(status: PortfolioStoriesStatus.loading));
    try {
      final items = await repository.getCategories();
      emit(
        state.copyWith(status: PortfolioStoriesStatus.success, items: items),
      );
    } catch (e, st) {
      AppLogger.e('Portfolio stories load failed', error: e, stackTrace: st);
      emit(state.copyWith(status: PortfolioStoriesStatus.failure));
    }
  }

  Future<void> _view(
    PortfolioStoryViewed event,
    Emitter<PortfolioStoriesState> emit,
  ) async {
    final matches = state.items.where(
      (s) => s.id == event.id && s.canTrackView,
    );
    if (matches.isEmpty ||
        matches.first.isViewed ||
        state.viewedIds.contains(event.id)) {
      return;
    }
    emit(state.copyWith(viewedIds: {...state.viewedIds, event.id}));
    await repository.postStoryView(event.id);
  }
}
