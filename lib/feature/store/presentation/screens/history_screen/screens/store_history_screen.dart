import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/bloc/store_history_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/components/store_order_history_grid_item.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/components/store_order_history_grid_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/screens/store_history_screen_mixin.dart';

class StoreHistoryScreen extends StatelessWidget {
  const StoreHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StoreHistoryBloc>()..add(const StoreHistoryStarted()),
      child: const _StoreHistoryView(),
    );
  }
}

class _StoreHistoryView extends StatefulWidget {
  const _StoreHistoryView();

  @override
  State<_StoreHistoryView> createState() => _StoreHistoryViewState();
}

class _StoreHistoryViewState extends State<_StoreHistoryView>
    with StoreHistoryScreenMixin<_StoreHistoryView> {
  bool _onScrollNotification(ScrollNotification n, BuildContext context) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) {
      return false;
    }
    final m = n.metrics;
    if (m.pixels >= m.maxScrollExtent - 220) {
      onScrollNearEnd(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AppPageScaffold(
      title: 'Mahsulotlar tarixi',
      onBackTap: () => onBackTap(context),
      body: BlocConsumer<StoreHistoryBloc, StoreHistoryState>(
        listenWhen: (previous, current) =>
            current.loadMoreFailed && !previous.loadMoreFailed,
        listener: storeHistoryBlocListener,
        builder: (context, state) {
          final isInitialLoading =
              (state.status == StoreHistoryStatus.loading ||
                  state.status == StoreHistoryStatus.initial) &&
              state.items.isEmpty;

          return switch (state.status) {
            StoreHistoryStatus.failure when state.items.isEmpty =>
              TgsFailureContent(
                message: "Buyurtmalarni yuklashda xatolik",
                onRetry: () => retryFirstPage(context),
              ),
            _ when isInitialLoading => const StoreOrderHistoryGridSkeleton(),
            StoreHistoryStatus.success when state.items.isEmpty => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.shoppingCart,
                      size: 48,
                      color: context.appColors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Hali buyurtma yo'q",
                      style: context.textTheme.bodyLargeSemibold.copyWith(
                        color: context.appColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            _ => NotificationListener<ScrollNotification>(
              onNotification: (n) => _onScrollNotification(n, context),
              child: AppStaggeredScrollLimiter(
                key: ValueKey(
                  'store-history-grid-${state.pageNumber}-${state.items.length}',
                ),
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
                  itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.64,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return Skeletonizer.zone(
                        child: const StoreOrderHistorySkeletonCard(),
                      );
                    }
                    final order = state.items[index];
                    return AppStaggeredListItem(
                      position: index,
                      child: StoreOrderHistoryGridItem(
                        order: order,
                        onTap: () => onOrderTap(context, order.id),
                      ),
                    );
                  },
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}
