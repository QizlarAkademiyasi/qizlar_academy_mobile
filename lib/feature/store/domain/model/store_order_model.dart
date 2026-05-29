import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreOrderModel extends Equatable {
  const StoreOrderModel({
    required this.id,
    required this.userId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.status,
    required this.createdAt,
    this.productTitle = '',
    this.productThumbnail = '',
    this.productId,
    this.productType,
    this.productDescription,
    this.productBasePrice,
    this.productMedia = const [],
    this.variantAttributes = const [],
    this.promoCode,
    this.promoCodeUsedAt,
  });

  final String id;
  final String userId;
  final String variantId;
  final int quantity;
  final int unitPrice;
  final String status;
  final DateTime createdAt;
  final String productTitle;
  final String productThumbnail;
  final String? productId;
  final String? productType;
  final String? productDescription;
  final int? productBasePrice;
  final List<String> productMedia;
  final List<StoreOrderAttributeModel> variantAttributes;
  final String? promoCode;
  final DateTime? promoCodeUsedAt;

  @override
  List<Object?> get props => [
    id,
    userId,
    variantId,
    quantity,
    unitPrice,
    status,
    createdAt,
    productTitle,
    productThumbnail,
    productId,
    productType,
    productDescription,
    productBasePrice,
    productMedia,
    variantAttributes,
    promoCode,
    promoCodeUsedAt,
  ];
}

class StoreOrderAttributeModel extends Equatable {
  const StoreOrderAttributeModel({required this.key, required this.value});

  final String key;
  final String value;

  @override
  List<Object?> get props => [key, value];
}
