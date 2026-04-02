part of 'my_courses_bloc.dart';

enum MyCoursesStatus { initial, loading, success, failure }

class MyCoursesState extends Equatable {
  const MyCoursesState({
    this.status = MyCoursesStatus.initial,
    this.courses = const [],
    this.pageNumber = 1,
    this.pageCount = 1,
    this.pageSize = 10,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.message,
  });

  final MyCoursesStatus status;
  final List<MyCourseItemModel> courses;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? message;

  MyCoursesState copyWith({
    MyCoursesStatus? status,
    List<MyCourseItemModel>? courses,
    int? pageNumber,
    int? pageCount,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? message,
    bool clearMessage = false,
  }) {
    return MyCoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    courses,
    pageNumber,
    pageCount,
    pageSize,
    hasMore,
    isLoadingMore,
    loadMoreFailed,
    message,
  ];
}
