import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class HomeStatsModel extends Equatable {
  const HomeStatsModel({
    required this.coins,
    required this.streakDays,
    required this.rating,
    required this.lastLessonCategory,
    required this.lastLessonProgress,
  });

  final int coins;
  final int streakDays;
  final int rating;
  final String lastLessonCategory;
  final double lastLessonProgress;

  @override
  List<Object?> get props => [
    coins,
    streakDays,
    rating,
    lastLessonCategory,
    lastLessonProgress,
  ];
}
