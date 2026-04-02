part of 'course_details_bloc.dart';

enum CoursesStatus { initial, loading, success, failure }

class CourseDetailsState extends Equatable {
  const CourseDetailsState({
    this.status = CoursesStatus.initial,
    this.course,
    this.message,
    this.isEnrolling = false,
    this.enrollError,
    this.openLessonPlayerPending = false,
    this.openLessonPlayerLessonId,
  });

  final CoursesStatus status;
  final CourseDetailsModel? course;
  final String? message;
  final bool isEnrolling;
  final String? enrollError;
  /// Yozilish muvaffaqiyatidan keyin [CourseLessonPlayer] ga o‘tish (bloc listener).
  final bool openLessonPlayerPending;
  /// `null` — keyingi dars / continue qoidasi; bo‘sh emas bo‘lsa shu dars.
  final String? openLessonPlayerLessonId;

  CourseDetailsState copyWith({
    CoursesStatus? status,
    CourseDetailsModel? course,
    String? message,
    bool clearMessage = false,
    bool? isEnrolling,
    String? enrollError,
    bool clearEnrollError = false,
    bool? openLessonPlayerPending,
    String? openLessonPlayerLessonId,
    bool clearOpenLessonPlayerPending = false,
  }) {
    return CourseDetailsState(
      status: status ?? this.status,
      course: course ?? this.course,
      message: clearMessage ? null : (message ?? this.message),
      isEnrolling: isEnrolling ?? this.isEnrolling,
      enrollError: clearEnrollError ? null : (enrollError ?? this.enrollError),
      openLessonPlayerPending: clearOpenLessonPlayerPending
          ? false
          : (openLessonPlayerPending ?? this.openLessonPlayerPending),
      openLessonPlayerLessonId: clearOpenLessonPlayerPending
          ? null
          : (openLessonPlayerLessonId ?? this.openLessonPlayerLessonId),
    );
  }

  @override
  List<Object?> get props => [
    status,
    course,
    message,
    isEnrolling,
    enrollError,
    openLessonPlayerPending,
    openLessonPlayerLessonId,
  ];
}
