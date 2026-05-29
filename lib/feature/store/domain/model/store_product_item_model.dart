import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_type.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_variant_model.dart';

class StoreProductItemModel extends Equatable {
  const StoreProductItemModel({
    required this.id,
    required this.title,
    required this.basePrice,
    required this.type,
    required this.isActive,
    required this.categoryId,
    required this.thumbnail,
    required this.media,
    required this.variants,
    required this.isLiked,
    required this.createdAt,
  });

  final String id;
  final String title;
  final int basePrice;
  final StoreProductType type;
  final bool isActive;
  final String categoryId;
  final String thumbnail;
  final List<StoreMediaModel> media;
  final List<StoreVariantModel> variants;
  final bool isLiked;
  final DateTime createdAt;

  int get totalStock => variants.fold(0, (sum, v) => sum + v.stock.available);

  StoreProductItemModel copyWith({bool? isLiked}) {
    return StoreProductItemModel(
      id: id,
      title: title,
      basePrice: basePrice,
      type: type,
      isActive: isActive,
      categoryId: categoryId,
      thumbnail: thumbnail,
      media: media,
      variants: variants,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, basePrice, type, isActive, categoryId, thumbnail, media, variants, isLiked, createdAt];
}
