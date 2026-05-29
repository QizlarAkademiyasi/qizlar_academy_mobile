import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// `/activity/stats` dan kelgan yagona ustun (Du…Ya yoki oy kun raqami).
class ActivityBarModel extends Equatable {
  const ActivityBarModel({
    required this.label,
    required this.durationMinutes,
    required this.isToday,
  });

  final String label;
  final int durationMinutes;
  final bool isToday;

  @override
  List<Object?> get props => [label, durationMinutes, isToday];
}
