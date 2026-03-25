import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';

part 'courses_catalog_event.dart';
part 'courses_catalog_state.dart';

class CoursesCatalogBloc
    extends Bloc<CoursesCatalogEvent, CoursesCatalogState> {
  CoursesCatalogBloc(this._repository) : super(const CoursesCatalogState()) {
    on<CoursesCatalogStarted>(_onStarted);
    on<CoursesCatalogRetryRequested>(_onRetryRequested);
    on<CoursesCatalogSearchChanged>(_onSearchChanged);
  }

  final CoursesCatalogRepository _repository;

  Future<void> _onStarted(
    CoursesCatalogStarted event,
    Emitter<CoursesCatalogState> emit,
  ) async {
    final effectiveQuery = event.query ?? state.query;
    await _loadCatalog(emit, query: effectiveQuery);
  }

  Future<void> _onRetryRequested(
    CoursesCatalogRetryRequested event,
    Emitter<CoursesCatalogState> emit,
  ) async {
    add(CoursesCatalogStarted(query: state.query));
  }

  Future<void> _onSearchChanged(
    CoursesCatalogSearchChanged event,
    Emitter<CoursesCatalogState> emit,
  ) async {
    if (event.query == state.query) return;
    emit(state.copyWith(query: event.query));
    await _loadCatalog(emit, query: event.query);
  }

  Future<void> _loadCatalog(
    Emitter<CoursesCatalogState> emit, {
    required String query,
  }) async {
    emit(
      state.copyWith(
        status: CoursesCatalogStatus.loading,
        query: query,
        clearMessage: true,
      ),
    );

    try {
      final overview = await _repository.fetchCatalog(query: query);
      emit(
        state.copyWith(
          status: CoursesCatalogStatus.success,
          overview: overview,
          clearMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CoursesCatalogStatus.failure,
          message: 'Kurslarni yuklashda xatolik yuz berdi.',
        ),
      );
    }
  }
}
