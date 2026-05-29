import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_value_model.dart';

class StoreAttributeGroupModel extends Equatable {
  const StoreAttributeGroupModel({required this.key, required this.values});

  final String key;
  final List<StoreAttributeValueModel> values;

  @override
  List<Object?> get props => [key, values];
}
