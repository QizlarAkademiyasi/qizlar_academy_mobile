import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseLessonModel extends Equatable {
  const CourseLessonModel({
    required this.id,
    required this.order,
    required this.title,
    required this.duration,
    required this.isLocked,
    required this.isCompleted,
    this.videoUrl,
    this.quizPassed = false,
    this.quizCorrectCount,
    this.quizTotalCount,
    this.hasQuiz = true,
    this.isQuizAttempted = false,
  });

  final String id;
  final int order;
  final String title;

  /// UI uchun tayyor ko‘rinish (masalan: "12:30" yoki "08:45").
  final String duration;

  final bool isLocked;
  final bool isCompleted;
  final String? videoUrl;

  /// Dars testi muvaffaqiyatli yakunlangan (API `quizPassed` / `isQuizPassed` yoki `isAttempted: true`).
  final bool quizPassed;

  /// Test natijasi: to‘g‘ri javoblar soni (masalan 4).
  final int? quizCorrectCount;

  /// Test savollari / maksimal ball (masalan 5).
  final int? quizTotalCount;

  /// `/module` ro‘yxatida `hasQuiz` (yo‘q bo‘lsa, default `true` — eski backend).
  final bool hasQuiz;

  /// Testga qatnashilgan (`isAttempted`). API javobida o‘tganlik bilan birga kelishi mumkin.
  final bool isQuizAttempted;

  /// Test muvaffaqiyatli yakunlangan (mahalliy submitda faqat `quizPassed`).
  bool get hasCompletedLessonQuiz => quizPassed;

  CourseLessonModel copyWith({
    String? id,
    int? order,
    String? title,
    String? duration,
    bool? isLocked,
    bool? isCompleted,
    String? videoUrl,
    bool? quizPassed,
    int? quizCorrectCount,
    int? quizTotalCount,
    bool? hasQuiz,
    bool? isQuizAttempted,
  }) {
    return CourseLessonModel(
      id: id ?? this.id,
      order: order ?? this.order,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      videoUrl: videoUrl ?? this.videoUrl,
      quizPassed: quizPassed ?? this.quizPassed,
      quizCorrectCount: quizCorrectCount ?? this.quizCorrectCount,
      quizTotalCount: quizTotalCount ?? this.quizTotalCount,
      hasQuiz: hasQuiz ?? this.hasQuiz,
      isQuizAttempted: isQuizAttempted ?? this.isQuizAttempted,
    );
  }

  @override
  List<Object?> get props => [id, order, title, duration, isLocked, isCompleted, videoUrl, quizPassed, quizCorrectCount, quizTotalCount, hasQuiz, isQuizAttempted];
}
