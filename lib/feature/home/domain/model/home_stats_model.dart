import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class HomeStatsModel extends Equatable {
  const HomeStatsModel({
    required this.coins,
    required this.grade,
    required this.rating,
    required this.lastLessonCategory,
    required this.lastLessonProgress,
  });

  final int coins;
  final int grade;
  final int rating;
  final String lastLessonCategory;
  final double lastLessonProgress;

  @override
  List<Object?> get props => [
    coins,
    grade,
    rating,
    lastLessonCategory,
    lastLessonProgress,
  ];
}
