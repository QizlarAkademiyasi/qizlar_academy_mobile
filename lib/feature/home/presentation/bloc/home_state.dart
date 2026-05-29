part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.homeStats,
    this.categories = const [],
    this.categoriesLoading = false,
    this.teachers = const [],
    this.courses = const [],
    this.banners = const [],
    this.userGreetingName = '',
    this.message,
  });

  final HomeStatus status;
  final HomeStatsModel? homeStats;
  final List<StoryModel> categories;
  final bool categoriesLoading;
  final List<TeacherModel> teachers;
  final List<CourseModel> courses;
  final List<BannerModel> banners;
  /// Ro‘yxatdan o‘tgan foydalanuvchi uchun AppBar sarlavhasi (profildan).
  final String userGreetingName;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    HomeStatsModel? homeStats,
    List<StoryModel>? categories,
    bool? categoriesLoading,
    List<TeacherModel>? teachers,
    List<CourseModel>? courses,
    List<BannerModel>? banners,
    String? userGreetingName,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeStats: homeStats ?? this.homeStats,
      categories: categories ?? this.categories,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      teachers: teachers ?? this.teachers,
      courses: courses ?? this.courses,
      banners: banners ?? this.banners,
      userGreetingName: userGreetingName ?? this.userGreetingName,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    homeStats,
    categories,
    categoriesLoading,
    teachers,
    courses,
    banners,
    userGreetingName,
    message,
  ];
}
