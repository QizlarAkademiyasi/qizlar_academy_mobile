import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class NeighborhoodModel extends Equatable with CustomDropdownListFilter {
  const NeighborhoodModel({
    required this.id,
    required this.name,
    required this.districtId,
    this.kod = 0,
  });

  final int id;
  final String name;
  final int districtId;

  /// Mahalla kodi; ba'zi API `neighborhoodId` da `id` o'rniga shuni yuboradi.
  final int kod;

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return NeighborhoodModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      districtId: (json['district_id'] as num).toInt(),
      kod: (json['kod'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());

  @override
  String toString() => name;

  @override
  List<Object?> get props => [id, name, districtId, kod];
}
