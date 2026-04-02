import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._repository,
    this._profileRepository,
    this._authSessionCubit,
  ) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }

  final HomeRepository _repository;
  final ProfileRepository _profileRepository;
  final AuthSessionCubit _authSessionCubit;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        categoriesLoading: true,
        message: null,
      ),
    );

    Object? failure;

    try {
      await Future.wait<void>([
        _loadCategories(emit).catchError((error, stackTrace) {
          failure ??= error;
        }),
        _loadMainContent(emit).catchError((error, stackTrace) {
          failure ??= error;
        }),
      ]);

      if (failure != null) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            message: failure.toString(),
          ),
        );
        return;
      }

      emit(state.copyWith(status: HomeStatus.success, message: null));
    } catch (error) {
      emit(state.copyWith(status: HomeStatus.failure, message: error.toString()));
    }
  }

  Future<void> _loadCategories(Emitter<HomeState> emit) async {
    try {
      final categories = await _repository.getCategories();
      emit(
        state.copyWith(
          categories: categories,
          categoriesLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(categoriesLoading: false));
      rethrow;
    }
  }

  Future<void> _loadMainContent(Emitter<HomeState> emit) async {
    Future<String> loadUserGreetingName() async {
      if (!_authSessionCubit.state.isRegistered) return '';
      try {
        final overview = await _profileRepository.getProfileOverview();
        final first = overview.user.firstName.trim();
        if (first.isNotEmpty) return first;
        final full = overview.user.fullName.trim();
        if (full.isNotEmpty) return full;
      } catch (_) {}
      return '';
    }

    final results = await Future.wait<Object?>([
      _repository.getStats(),
      _repository.getTeachers(),
      _repository.getCourses(),
      _repository.getBanners(),
      loadUserGreetingName(),
    ]);
    emit(
      state.copyWith(
        homeStats: results[0] as HomeStatsModel,
        teachers: results[1] as List<TeacherModel>,
        courses: results[2] as List<CourseModel>,
        banners: results[3] as List<BannerModel>,
        userGreetingName: results[4] as String,
      ),
    );
  }
}
