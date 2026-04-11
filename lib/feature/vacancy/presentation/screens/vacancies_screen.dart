import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/bloc/vacancy_bloc.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/components/vacancies_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancies_screen_mixin.dart';

class VacanciesScreen extends StatelessWidget {
  const VacanciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<VacancyBloc>()..add(const VacancyStarted()), child: const _VacanciesView());
  }
}

class _VacanciesView extends StatefulWidget {
  const _VacanciesView();

  @override
  State<_VacanciesView> createState() => _VacanciesViewState();
}

class _VacanciesViewState extends State<_VacanciesView> with VacanciesScreenMixin<_VacanciesView> {
  bool _onScrollNotification(ScrollNotification n, BuildContext context) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is! ScrollUpdateNotification && n is! OverscrollNotification) {
      return false;
    }
    final m = n.metrics;
    if (m.pixels >= m.maxScrollExtent - 220) {
      onVacancyScrollNearEnd(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<VacancyBloc, VacancyState>(
          listenWhen: (previous, current) => current.loadMoreFailed && !previous.loadMoreFailed,
          listener: vacancyBlocListener,
          builder: (context, state) {
            final isInitialLoading = (state.status == VacancyStatus.loading || state.status == VacancyStatus.initial) && state.items.isEmpty;

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: buildVacanciesTopBar(context)),
                    Expanded(
                      child: switch (state.status) {
                        VacancyStatus.failure when state.items.isEmpty => TgsFailureContent(message: context.l10n.vacanciesLoadError, onRetry: () => retryVacanciesFirstPage(context)),
                        _ when isInitialLoading => const Padding(padding: EdgeInsets.only(top: 4), child: VacanciesListSkeleton()),
                        VacancyStatus.success when state.items.isEmpty => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: TgsEmptyContent(message: context.l10n.vacanciesEmptyTitle, subtitle: context.l10n.vacanciesEmptySubtitle),
                          ),
                        ),
                        _ => NotificationListener<ScrollNotification>(
                          onNotification: (n) => _onScrollNotification(n, context),
                          child: AppStaggeredScrollLimiter(
                            child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate((context, index) {
                                      if (index >= state.items.length) {
                                        return Skeletonizer.zone(
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            child: Center(child: Bone.text(words: 4)),
                                          ),
                                        );
                                      }
                                      return AppStaggeredListItem(
                                        position: index,
                                        child: buildVacancyListItem(context, state: state, index: index),
                                      );
                                    }, childCount: state.items.length + (state.isLoadingMore ? 1 : 0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: context.isDarkTheme ? UiKitAssets.images.bottomNavDark.image(fit: BoxFit.cover) : UiKitAssets.images.bottomNavLight.image(fit: BoxFit.cover),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
