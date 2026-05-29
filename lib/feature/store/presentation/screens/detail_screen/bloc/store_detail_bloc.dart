import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/core/analytics/meta_analytics_service.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_result_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_variant_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/repository/store_repository.dart';

part 'store_detail_event.dart';
part 'store_detail_state.dart';

class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  StoreDetailBloc(this._repository) : super(const StoreDetailState()) {
    on<StoreDetailStarted>(_onStarted);
    on<StoreDetailRetryRequested>(_onRetry);
    on<StoreDetailVariantSelected>(_onVariantSelected);
    on<StoreDetailOrderRequested>(_onOrderRequested);
    on<StoreDetailLikeToggled>(_onLikeToggled);
    on<StoreDetailOrderResultConsumed>(_onOrderResultConsumed);
  }

  final StoreRepository _repository;

  Future<void> _onStarted(StoreDetailStarted event, Emitter<StoreDetailState> emit) async {
    emit(state.copyWith(status: StoreDetailStatus.loading, clearOrderResult: true));
    await _loadProduct(event.productId, emit);
  }

  Future<void> _onRetry(StoreDetailRetryRequested event, Emitter<StoreDetailState> emit) async {
    final id = state.product?.id;
    if (id == null) return;
    emit(state.copyWith(status: StoreDetailStatus.loading));
    await _loadProduct(id, emit);
  }

  Future<void> _loadProduct(String id, Emitter<StoreDetailState> emit) async {
    try {
      final product = await _repository.fetchProductById(id);
      final selectedVariant = product.variants.isNotEmpty ? product.variants.first : null;
      emit(state.copyWith(status: StoreDetailStatus.success, product: product, selectedVariant: selectedVariant));
      unawaited(
        getIt<MetaAnalyticsService>().logViewContent(
          contentId: product.id,
          contentType: 'store_product',
          extraParameters: <String, dynamic>{
            'fb_content_name': product.title,
            'fb_content_category': product.categoryId,
          },
        ),
      );
    } catch (e, st) {
      AppLogger.e('StoreDetailBloc: load failed', error: e, stackTrace: st);
      emit(state.copyWith(status: StoreDetailStatus.failure));
    }
  }

  void _onVariantSelected(StoreDetailVariantSelected event, Emitter<StoreDetailState> emit) {
    final variant = state.product?.variants.firstWhere((v) => v.id == event.variantId, orElse: () => state.selectedVariant!);
    if (variant != null) emit(state.copyWith(selectedVariant: variant));
  }

  Future<void> _onOrderRequested(StoreDetailOrderRequested event, Emitter<StoreDetailState> emit) async {
    final variant = state.selectedVariant;
    if (variant == null) return;
    emit(state.copyWith(isOrdering: true, clearOrderResult: true));
    try {
      final result = await _repository.createOrder(variantId: variant.id);
      emit(state.copyWith(isOrdering: false, orderResult: result));
      unawaited(
        getIt<MetaAnalyticsService>().logStoreOrderCompleted(
          orderId: result.orderId,
          productId: state.product?.id,
          variantId: variant.id,
          unitPriceCoins: result.unitPrice,
        ),
      );
    } catch (e, st) {
      AppLogger.e('StoreDetailBloc: order failed', error: e, stackTrace: st);
      emit(state.copyWith(isOrdering: false, orderError: _resolveOrderError(e)));
    }
  }

  Future<void> _onLikeToggled(StoreDetailLikeToggled event, Emitter<StoreDetailState> emit) async {
    final product = state.product;
    if (product == null) return;
    emit(state.copyWith(product: product.copyWith(isLiked: !product.isLiked)));
    try {
      await _repository.toggleLike(product.id);
    } catch (e, st) {
      AppLogger.e('StoreDetailBloc: like toggle failed', error: e, stackTrace: st);
      emit(state.copyWith(product: state.product?.copyWith(isLiked: !state.product!.isLiked)));
    }
  }

  void _onOrderResultConsumed(StoreDetailOrderResultConsumed event, Emitter<StoreDetailState> emit) {
    emit(state.copyWith(clearOrderResult: true, clearOrderError: true));
  }

  String _resolveOrderError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message']?.toString().trim();
        if (message != null && message.isNotEmpty) return message;
      }

      final message = error.message?.trim();
      if (message != null && message.isNotEmpty) return message;
    }
    return error.toString();
  }
}
