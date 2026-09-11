import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_startup_snapshot.dart';
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
    this._startupCache,
  ) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeUserGreetingRefreshRequested>(_onUserGreetingRefreshRequested);
  }

  final HomeRepository _repository;
  final ProfileRepository _profileRepository;
  final AuthSessionCubit _authSessionCubit;
  final HomeStartupCache _startupCache;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    final cached = _startupCache.consumeIfMatches(
      _authSessionCubit.state.userType,
    );
    if (cached != null) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          homeStats: cached.homeStats,
          teachers: cached.teachers,
          courses: cached.courses,
          banners: cached.banners,
          userGreetingName: cached.userGreetingName,
          message: null,
        ),
      );
      return;
    }

    emit(state.copyWith(status: HomeStatus.loading, message: null));

    try {
      await _loadMainContent(emit);
      emit(state.copyWith(status: HomeStatus.success));
    } catch (error, stackTrace) {
      AppLogger.e('Home load failed', error: error, stackTrace: stackTrace);
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<String> _loadUserGreetingName() async {
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

  Future<void> _onUserGreetingRefreshRequested(
    HomeUserGreetingRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    final name = await _loadUserGreetingName();
    emit(state.copyWith(userGreetingName: name));
  }

  Future<void> _loadMainContent(Emitter<HomeState> emit) async {
    final results = await Future.wait<Object?>([
      _repository.getStats(),
      _repository.getTeachers(),
      _repository.getCourses(),
      _repository.getBanners(),
      _loadUserGreetingName(),
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
