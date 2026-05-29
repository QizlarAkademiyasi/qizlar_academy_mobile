import 'package:flutter/material.dart';

/// [LessonQuizScreen] ga `extra` orqali beriladi: oxirgi dars testidan so‘ng sertifikat API chaqirilsinmi.
class LessonQuizLaunchContext {
  const LessonQuizLaunchContext({
    required this.courseId,
    required this.courseName,
    required this.requestCertificateOnPass,
  });

  final String courseId;
  final String courseName;
  final bool requestCertificateOnPass;
}

class LessonQuizLaunchScope extends InheritedWidget {
  const LessonQuizLaunchScope({super.key, required this.launch, required super.child});

  final LessonQuizLaunchContext? launch;

  static LessonQuizLaunchContext? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LessonQuizLaunchScope>()?.launch;
  }

  @override
  bool updateShouldNotify(covariant LessonQuizLaunchScope oldWidget) {
    return launch != oldWidget.launch;
  }
}
