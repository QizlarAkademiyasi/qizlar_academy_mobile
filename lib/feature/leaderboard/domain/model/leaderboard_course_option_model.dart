import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Dropdown uchun kurs variant — API'dan keladigan id/name bilan mos.
class LeaderboardCourseOptionModel extends Equatable {
  const LeaderboardCourseOptionModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
