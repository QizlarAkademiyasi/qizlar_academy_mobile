import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_course_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/repository/my_courses_repository.dart';

part 'my_courses_event.dart';
part 'my_courses_state.dart';

class MyCoursesBloc extends Bloc<MyCoursesEvent, MyCoursesState> {
  MyCoursesBloc(this._repository) : super(const MyCoursesState()) {
    on<MyCoursesStarted>(_onStarted);
    on<MyCoursesRetryRequested>(_onRetryRequested);
    on<MyCoursesLoadMoreRequested>(_onLoadMoreRequested);
    on<MyCoursesLoadMoreFailureConsumed>(_onLoadMoreFailureConsumed);
  }

  final MyCoursesRepository _repository;

  static const int _pageSize = 10;

  Future<void> _onStarted(MyCoursesStarted event, Emitter<MyCoursesState> emit) async {
    emit(state.copyWith(status: MyCoursesStatus.loading, courses: const [], clearMessage: true, loadMoreFailed: false, isLoadingMore: false));
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(MyCoursesRetryRequested event, Emitter<MyCoursesState> emit) async {
    emit(state.copyWith(status: MyCoursesStatus.loading, clearMessage: true, loadMoreFailed: false));
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<MyCoursesState> emit) async {
    try {
      final page = await _repository.fetchPage(pageNumber: 1, pageSize: _pageSize);
      emit(
        state.copyWith(
          status: MyCoursesStatus.success,
          courses: page.items,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          clearMessage: true,
          loadMoreFailed: false,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('MyCoursesBloc: first page failed', error: e, stackTrace: st);
      emit(state.copyWith(status: MyCoursesStatus.failure, courses: const [], hasMore: false, clearMessage: true));
    }
  }

  Future<void> _onLoadMoreRequested(MyCoursesLoadMoreRequested event, Emitter<MyCoursesState> emit) async {
    if (state.status != MyCoursesStatus.success) return;
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.pageNumber + 1;
    try {
      final page = await _repository.fetchPage(pageNumber: nextPage, pageSize: state.pageSize);
      final merged = List<MyCourseItemModel>.from(state.courses)..addAll(page.items);
      emit(
        state.copyWith(
          status: MyCoursesStatus.success,
          courses: merged,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          isLoadingMore: false,
          loadMoreFailed: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('MyCoursesBloc: load more failed', error: e, stackTrace: st);
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  void _onLoadMoreFailureConsumed(MyCoursesLoadMoreFailureConsumed event, Emitter<MyCoursesState> emit) {
    emit(state.copyWith(loadMoreFailed: false));
  }
}
