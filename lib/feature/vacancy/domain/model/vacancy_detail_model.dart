import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_skill_model.dart';

class VacancyDetailModel extends Equatable {
  const VacancyDetailModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.description,
    required this.requirements,
    required this.salaryFrom,
    required this.salaryTo,
    required this.category,
    required this.currency,
    required this.location,
    required this.type,
    required this.skills,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String companyName;
  final String description;
  final String requirements;
  final int salaryFrom;
  final int salaryTo;
  final String category;
  final String currency;
  final String location;
  final String type;
  final List<VacancySkillModel> skills;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        description,
        requirements,
        salaryFrom,
        salaryTo,
        category,
        currency,
        location,
        type,
        skills,
        createdAt,
      ];
}
