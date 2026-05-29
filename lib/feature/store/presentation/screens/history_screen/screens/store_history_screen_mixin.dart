import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/bloc/store_history_bloc.dart';

mixin StoreHistoryScreenMixin<T extends StatefulWidget> on State<T> {
  void storeHistoryBlocListener(BuildContext context, StoreHistoryState state) {
    if (!state.loadMoreFailed) return;
    AppToast.error(context, message: "Ko'proq yuklashda xatolik");
    context.read<StoreHistoryBloc>().add(const StoreHistoryLoadMoreFailureConsumed());
  }

  void onBackTap(BuildContext context) {
    context.pop();
  }

  void onScrollNearEnd(BuildContext context) {
    context.read<StoreHistoryBloc>().add(const StoreHistoryLoadMoreRequested());
  }

  void retryFirstPage(BuildContext context) {
    context.read<StoreHistoryBloc>().add(const StoreHistoryRetryRequested());
  }

  void onOrderTap(BuildContext context, String orderId) {
    context.push(Routes.storeOrderDetail(orderId));
  }
}
