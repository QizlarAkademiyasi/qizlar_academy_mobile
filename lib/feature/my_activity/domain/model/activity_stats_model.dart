import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_bar_model.dart';

class ActivityStatsModel extends Equatable {
  const ActivityStatsModel({
    required this.bars,
    required this.totalDurationMinutes,
    required this.averageDurationMinutes,
    required this.dailyRecordMinutes,
    required this.completedCourses,
  });

  final List<ActivityBarModel> bars;
  final int totalDurationMinutes;
  final int averageDurationMinutes;
  final int dailyRecordMinutes;
  final int completedCourses;

  @override
  List<Object?> get props => [
    bars,
    totalDurationMinutes,
    averageDurationMinutes,
    dailyRecordMinutes,
    completedCourses,
  ];
}
