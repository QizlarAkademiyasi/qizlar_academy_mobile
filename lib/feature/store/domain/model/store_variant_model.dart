import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_value_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_stock_model.dart';

class StoreVariantModel extends Equatable {
  const StoreVariantModel({
    required this.id,
    required this.price,
    required this.isActive,
    required this.attributes,
    required this.media,
    required this.stock,
  });

  final String id;
  final int price;
  final bool isActive;
  final List<StoreAttributeValueModel> attributes;
  final List<StoreMediaModel> media;
  final StoreStockModel stock;

  bool get isSoldOut => stock.isSoldOut;

  @override
  List<Object?> get props => [id, price, isActive, attributes, media, stock];
}
