import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class RegionModel extends Equatable with CustomDropdownListFilter {
  const RegionModel({
    required this.id,
    required this.name,
    required this.countryId,
    this.kod = 0,
  });

  final int id;
  final String name;

  /// `regions.json` dagi `country_id` — `PATCH /user/me` uchun.
  final int countryId;

  /// Statistik / tashqi tizimlar uchun viloyat kodi; ba'zi API `regionId` da shuni yuboradi.
  final int kod;

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      countryId: (json['country_id'] as num?)?.toInt() ?? 0,
      kod: (json['kod'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());

  @override
  String toString() => name;

  @override
  List<Object?> get props => [id, name, countryId, kod];
}
