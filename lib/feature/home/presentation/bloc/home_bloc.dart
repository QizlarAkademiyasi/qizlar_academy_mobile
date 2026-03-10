import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }

  final HomeRepository _repository;

  Future<void> _onHomeStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final results = await Future.wait([
        _repository.getStats(),
        _repository.getCategories(),
        _repository.getTeachers(),
        _repository.getCourses(),
      ]);
      emit(
        state.copyWith(
          status: HomeStatus.success,
          homeStats: results[0] as HomeStatsModel,
          categories: results[1] as List<CategoryModel>,
          teachers: results[2] as List<TeacherModel>,
          courses: results[3] as List<CourseModel>,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, message: e.toString()));
    }
  }
}
