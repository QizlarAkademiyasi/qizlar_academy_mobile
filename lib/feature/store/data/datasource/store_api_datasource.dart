import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/store/data/datasource/store_datasource.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_group_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_value_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_category_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_result_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_orders_page_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_pagination_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_item_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_type.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_products_page_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_stock_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_variant_model.dart';

class StoreApiDatasource implements StoreDatasource {
  const StoreApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<List<StoreCategoryModel>> fetchCategories() async {
    final response = await _dio.get<dynamic>(StoreApis.productCategoriesPublic);
    final envelope = _asMap(response.data);
    final rawList = _asList(envelope['data']);
    return rawList
        .map(
          (m) => StoreCategoryModel(
            id: (m['id'] ?? '').toString(),
            name: (m['name'] ?? '').toString(),
          ),
        )
        .where((c) => c.id.isNotEmpty && c.name.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<StoreProductsPageModel> fetchProducts({required int pageNumber, required int pageSize, String? categoryId}) async {
    final qp = <String, dynamic>{'pageNumber': pageNumber, 'pageSize': pageSize};
    if (categoryId != null && categoryId.isNotEmpty) qp['categoryId'] = categoryId;

    final response = await _dio.get<dynamic>(StoreApis.productsClient, queryParameters: qp);
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final rawList = _asList(data['data']);
    final items = rawList.map(_mapProductItem).toList(growable: false);

    final meta = _asMapOrNull(data['meta']);
    final paginationRaw = _asMapOrNull(meta?['pagination']);
    final pagination = _mapPagination(paginationRaw, fallbackPageSize: pageSize);

    return StoreProductsPageModel(items: items, pagination: pagination);
  }

  @override
  Future<StoreProductDetailModel> fetchProductById(String id) async {
    final response = await _dio.get<dynamic>(StoreApis.productClientById(id));
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    return _mapProductDetail(data);
  }

  @override
  Future<void> toggleLike(String productId) async {
    await _dio.post<dynamic>(StoreApis.productLike(productId));
  }

  @override
  Future<StoreOrderResultModel> createOrder({required String variantId}) async {
    final response = await _dio.post<dynamic>(StoreApis.orders, data: <String, dynamic>{'variantId': variantId});
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final promoRaw = data['promoCode'];
    String? promoCode;
    if (promoRaw is Map) {
      promoCode = (promoRaw['code'] ?? '').toString();
      if (promoCode.isEmpty) promoCode = null;
    }
    return StoreOrderResultModel(
      orderId: (data['id'] ?? '').toString(),
      status: (data['status'] ?? 'PENDING').toString(),
      unitPrice: _parseInt(data['unitPrice']),
      promoCode: promoCode,
    );
  }

  @override
  Future<StoreOrdersPageModel> fetchMyOrders({required int pageNumber, required int pageSize}) async {
    final response = await _dio.get<dynamic>(StoreApis.orders, queryParameters: <String, dynamic>{'pageNumber': pageNumber, 'pageSize': pageSize});
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final rawList = _asList(data['data']);
    final items = rawList.map(_mapOrder).toList(growable: false);

    final meta = _asMapOrNull(data['meta']);
    final paginationRaw = _asMapOrNull(meta?['pagination']);
    final pagination = _mapPagination(paginationRaw, fallbackPageSize: pageSize);

    return StoreOrdersPageModel(items: items, pagination: pagination);
  }

  @override
  Future<StoreOrderModel> fetchOrderById(String orderId) async {
    final response = await _dio.get<dynamic>(StoreApis.orderById(orderId));
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    return _mapOrder(data);
  }

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  StoreProductItemModel _mapProductItem(Map<String, dynamic> m) {
    return StoreProductItemModel(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '').toString(),
      basePrice: _parseInt(m['basePrice']),
      type: StoreProductType.fromString((m['type'] ?? '').toString()),
      isActive: m['isActive'] == true,
      categoryId: (m['categoryId'] ?? '').toString(),
      thumbnail: Apis.resolveUrl((m['thumbnail'] ?? '').toString()),
      media: _mapMediaList(m['media']),
      variants: _mapVariantList(m['variants']),
      isLiked: m['isLiked'] == true,
      createdAt: _parseDate(m['createdAt']),
    );
  }

  StoreProductDetailModel _mapProductDetail(Map<String, dynamic> m) {
    return StoreProductDetailModel(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '').toString(),
      description: (m['description'] ?? '').toString(),
      basePrice: _parseInt(m['basePrice']),
      type: StoreProductType.fromString((m['type'] ?? '').toString()),
      isActive: m['isActive'] == true,
      categoryId: (m['categoryId'] ?? '').toString(),
      thumbnail: Apis.resolveUrl((m['thumbnail'] ?? '').toString()),
      media: _mapMediaList(m['media']),
      attributeGroups: _mapAttributeGroups(m['attributeGroups']),
      variants: _mapVariantList(m['variants']),
      isLiked: m['isLiked'] == true,
      createdAt: _parseDate(m['createdAt']),
    );
  }

  StoreOrderModel _mapOrder(Map<String, dynamic> m) {
    final product = _asMapOrNull(m['product']);
    final variant = _asMapOrNull(m['variant']);
    final attrs = variant != null ? _asList(variant['attributes']) : <Map<String, dynamic>>[];
    final promoRaw = m['promoCode'];
    String? promoCode;
    DateTime? promoCodeUsedAt;
    if (promoRaw is Map) {
      promoCode = (promoRaw['code'] ?? '').toString();
      if (promoCode.isEmpty) promoCode = null;
      final usedAtRaw = promoRaw['usedAt'];
      if (usedAtRaw != null && usedAtRaw.toString().trim().isNotEmpty) {
        promoCodeUsedAt = _parseDate(usedAtRaw);
      }
    }
    return StoreOrderModel(
      id: (m['id'] ?? '').toString(),
      userId: (m['userId'] ?? '').toString(),
      variantId: (m['variantId'] ?? '').toString(),
      quantity: _parseInt(m['quantity']),
      unitPrice: _parseInt(m['unitPrice']),
      status: (m['status'] ?? '').toString(),
      createdAt: _parseDate(m['createdAt']),
      productTitle: (m['productTitle'] ?? m['product']?['title'] ?? '').toString(),
      productThumbnail: Apis.resolveUrl((m['productThumbnail'] ?? m['product']?['thumbnail'] ?? '').toString()),
      productId: product?['id']?.toString(),
      productType: product?['type']?.toString(),
      productDescription: product?['description']?.toString(),
      productBasePrice: product?['basePrice'] != null ? _parseInt(product?['basePrice']) : null,
      productMedia: product != null
          ? _asList(product['media']).map((e) => Apis.resolveUrl((e['url'] ?? '').toString())).where((e) => e.isNotEmpty).toList(growable: false)
          : const [],
      variantAttributes: attrs.map((a) => StoreOrderAttributeModel(key: (a['key'] ?? '').toString(), value: (a['value'] ?? '').toString())).toList(growable: false),
      promoCode: promoCode,
      promoCodeUsedAt: promoCodeUsedAt,
    );
  }

  List<StoreMediaModel> _mapMediaList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((e) => _asMap(e))
        .where((m) => m.isNotEmpty)
        .map((m) => StoreMediaModel(id: (m['id'] ?? '').toString(), url: Apis.resolveUrl((m['url'] ?? '').toString())))
        .toList(growable: false);
  }

  List<StoreVariantModel> _mapVariantList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((e) => _asMap(e))
        .where((m) => m.isNotEmpty)
        .map((m) {
          final stockRaw = _asMapOrNull(m['stock']);
          final stock = stockRaw != null
              ? StoreStockModel(quantity: _parseInt(stockRaw['quantity']), reserved: _parseInt(stockRaw['reserved']), available: _parseInt(stockRaw['available']))
              : const StoreStockModel(quantity: 0, reserved: 0, available: 0);

          return StoreVariantModel(
            id: (m['id'] ?? '').toString(),
            price: _parseInt(m['price']),
            isActive: m['isActive'] != false,
            attributes: _mapAttributeValues(m['attributes']),
            media: _mapMediaList(m['media']),
            stock: stock,
          );
        })
        .toList(growable: false);
  }

  List<StoreAttributeValueModel> _mapAttributeValues(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((e) => _asMap(e))
        .where((m) => m.isNotEmpty)
        .map((m) {
          final hex = m['hexCode'];
          return StoreAttributeValueModel(id: (m['id'] ?? '').toString(), value: (m['value'] ?? '').toString(), hexCode: hex is String && hex.isNotEmpty ? hex : null);
        })
        .toList(growable: false);
  }

  List<StoreAttributeGroupModel> _mapAttributeGroups(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((e) => _asMap(e))
        .where((m) => m.isNotEmpty)
        .map((m) => StoreAttributeGroupModel(key: (m['key'] ?? '').toString(), values: _mapAttributeValues(m['values'])))
        .toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  StorePaginationModel _mapPagination(Map<String, dynamic>? p, {required int fallbackPageSize}) {
    if (p == null || p.isEmpty) {
      return StorePaginationModel(totalCount: 0, pageCount: 1, pageNumber: 1, pageSize: fallbackPageSize);
    }
    final rawPageCount = _parseInt(p['pageCount']);
    final safePageCount = rawPageCount <= 0 ? 1 : rawPageCount;
    return StorePaginationModel(
      totalCount: _parseInt(p['count']),
      pageCount: safePageCount,
      pageNumber: _parseInt(p['pageNumber']).clamp(1, 1 << 30),
      pageSize: _parseInt(p['pageSize']).clamp(1, 500),
    );
  }

  DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    final s = value.toString().trim();
    if (s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    try {
      return DateTime.parse(s).toLocal();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.map((key, value) => MapEntry(key.toString(), value));
    AppLogger.w('StoreApiDatasource: expected map envelope, got ${data.runtimeType}');
    return <String, dynamic>{};
  }

  Map<String, dynamic>? _asMapOrNull(dynamic data) {
    final map = _asMap(data);
    return map.isEmpty ? null : map;
  }

  List<Map<String, dynamic>> _asList(dynamic data) {
    if (data is! List) return const [];
    return data.map((e) => _asMap(e)).where((m) => m.isNotEmpty).toList(growable: false);
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('${value ?? 0}') ?? 0;
  }
}
