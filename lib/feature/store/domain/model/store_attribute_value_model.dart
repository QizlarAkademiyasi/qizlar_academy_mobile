import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreAttributeValueModel extends Equatable {
  const StoreAttributeValueModel({required this.id, required this.value, this.hexCode});

  final String id;
  final String value;
  final String? hexCode;

  @override
  List<Object?> get props => [id, value, hexCode];
}
