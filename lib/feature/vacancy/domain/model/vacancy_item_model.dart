import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class VacancyItemModel extends Equatable {
  const VacancyItemModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.salaryFrom,
    required this.salaryTo,
    required this.currency,
    required this.category,
    required this.location,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String companyName;
  final int salaryFrom;
  final int salaryTo;
  final String currency;
  final String category;
  final String location;
  final String type;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, companyName, salaryFrom, salaryTo, currency, category, location, type, createdAt];
}
