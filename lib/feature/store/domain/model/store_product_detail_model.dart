import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_group_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_type.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_variant_model.dart';

class StoreProductDetailModel extends Equatable {
  const StoreProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.type,
    required this.isActive,
    required this.categoryId,
    required this.thumbnail,
    required this.media,
    required this.attributeGroups,
    required this.variants,
    required this.isLiked,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final int basePrice;
  final StoreProductType type;
  final bool isActive;
  final String categoryId;
  final String thumbnail;
  final List<StoreMediaModel> media;
  final List<StoreAttributeGroupModel> attributeGroups;
  final List<StoreVariantModel> variants;
  final bool isLiked;
  final DateTime createdAt;

  int get totalStock => variants.fold(0, (sum, v) => sum + v.stock.available);

  StoreProductDetailModel copyWith({bool? isLiked}) {
    return StoreProductDetailModel(
      id: id,
      title: title,
      description: description,
      basePrice: basePrice,
      type: type,
      isActive: isActive,
      categoryId: categoryId,
      thumbnail: thumbnail,
      media: media,
      attributeGroups: attributeGroups,
      variants: variants,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, basePrice, type, isActive, categoryId, thumbnail, media, attributeGroups, variants, isLiked, createdAt];
}
