import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class VacancySkillModel extends Equatable {
  const VacancySkillModel({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
