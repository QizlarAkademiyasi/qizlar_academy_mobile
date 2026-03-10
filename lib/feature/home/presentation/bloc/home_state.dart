part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.homeStats,
    this.categories = const [],
    this.teachers = const [],
    this.courses = const [],
    this.message,
  });

  final HomeStatus status;
  final HomeStatsModel? homeStats;
  final List<CategoryModel> categories;
  final List<TeacherModel> teachers;
  final List<CourseModel> courses;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    HomeStatsModel? homeStats,
    List<CategoryModel>? categories,
    List<TeacherModel>? teachers,
    List<CourseModel>? courses,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeStats: homeStats ?? this.homeStats,
      categories: categories ?? this.categories,
      teachers: teachers ?? this.teachers,
      courses: courses ?? this.courses,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, homeStats, categories, teachers, courses, message];
}
