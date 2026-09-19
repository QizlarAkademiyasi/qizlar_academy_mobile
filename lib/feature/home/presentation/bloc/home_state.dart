part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.homeStats,
    this.teachers = const [],
    this.courses = const [],
    this.banners = const [],
    this.userGreetingName = '',
    this.userBadgeId = 0,
    this.message,
  });

  final HomeStatus status;
  final HomeStatsModel? homeStats;
  final List<TeacherModel> teachers;
  final List<CourseModel> courses;
  final List<BannerModel> banners;

  /// Ro‘yxatdan o‘tgan foydalanuvchi uchun salom qatori (profildan).
  final String userGreetingName;
  final int userBadgeId;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    HomeStatsModel? homeStats,
    List<TeacherModel>? teachers,
    List<CourseModel>? courses,
    List<BannerModel>? banners,
    String? userGreetingName,
    int? userBadgeId,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeStats: homeStats ?? this.homeStats,
      teachers: teachers ?? this.teachers,
      courses: courses ?? this.courses,
      banners: banners ?? this.banners,
      userGreetingName: userGreetingName ?? this.userGreetingName,
      userBadgeId: userBadgeId ?? this.userBadgeId,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    homeStats,
    teachers,
    courses,
    banners,
    userGreetingName,
    userBadgeId,
    message,
  ];
}
