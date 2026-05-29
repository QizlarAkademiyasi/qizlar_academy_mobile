import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class DistrictModel extends Equatable with CustomDropdownListFilter {
  const DistrictModel({
    required this.id,
    required this.name,
    required this.regionId,
    this.kod = 0,
  });

  final int id;
  final String name;
  final int regionId;

  /// Tuman SOATO / tashqi kod; ba'zi API `districtId` da `id` o'rniga shuni yuboradi.
  final int kod;

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      regionId: (json['region_id'] as num).toInt(),
      kod: (json['kod'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());

  @override
  String toString() => name;

  @override
  List<Object?> get props => [id, name, regionId, kod];
}
