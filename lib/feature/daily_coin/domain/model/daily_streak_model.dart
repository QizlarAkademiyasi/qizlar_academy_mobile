import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class DailyStreakModel extends Equatable {
  const DailyStreakModel({required this.streakCount, required this.isClaimed});

  /// Backend: 1–10 (reward coins equal this value when claimed).
  final int streakCount;

  final bool isClaimed;

  @override
  List<Object?> get props => [streakCount, isClaimed];
}
