import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/store/data/datasource/store_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_category_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_result_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_orders_page_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_products_page_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/repository/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  StoreRepositoryImpl({required StoreApiDatasource apiDatasource, required AuthSessionCubit authSessionCubit})
      : _apiDatasource = apiDatasource,
        _authSessionCubit = authSessionCubit;

  final StoreApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('Store is only available for registered users.');
    }
  }

  @override
  Future<List<StoreCategoryModel>> fetchCategories() {
    _ensureRegistered();
    return _apiDatasource.fetchCategories();
  }

  @override
  Future<StoreProductsPageModel> fetchProducts({required int pageNumber, int pageSize = 10, String? categoryId}) {
    _ensureRegistered();
    return _apiDatasource.fetchProducts(pageNumber: pageNumber, pageSize: pageSize, categoryId: categoryId);
  }

  @override
  Future<StoreProductDetailModel> fetchProductById(String id) {
    _ensureRegistered();
    return _apiDatasource.fetchProductById(id);
  }

  @override
  Future<void> toggleLike(String productId) {
    _ensureRegistered();
    return _apiDatasource.toggleLike(productId);
  }

  @override
  Future<StoreOrderResultModel> createOrder({required String variantId}) {
    _ensureRegistered();
    return _apiDatasource.createOrder(variantId: variantId);
  }

  @override
  Future<StoreOrdersPageModel> fetchMyOrders({required int pageNumber, int pageSize = 10}) {
    _ensureRegistered();
    return _apiDatasource.fetchMyOrders(pageNumber: pageNumber, pageSize: pageSize);
  }

  @override
  Future<StoreOrderModel> fetchOrderById(String orderId) {
    _ensureRegistered();
    return _apiDatasource.fetchOrderById(orderId);
  }
}
