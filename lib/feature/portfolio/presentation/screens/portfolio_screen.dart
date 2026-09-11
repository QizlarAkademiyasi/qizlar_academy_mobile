import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_stories_bloc.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/portfolio_screen_mixin.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<PortfolioBloc>()..add(const PortfolioStarted()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<PortfolioStoriesBloc>()
                ..add(const PortfolioStoriesStarted()),
        ),
      ],
      child: const _PortfolioView(),
    );
  }
}

class _PortfolioView extends StatefulWidget {
  const _PortfolioView();

  @override
  State<_PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<_PortfolioView>
    with SingleTickerProviderStateMixin, PortfolioScreenMixin<_PortfolioView> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final state = context.watch<PortfolioBloc>().state;

    return AppPageScaffold(
      title: 'Portfolio',
      onBackTap: () => onBackTap(context),
      actions: [
        if (!state.isGuest)
          IconButton(
            onPressed: () => onCreateTap(context, state),
            icon: const Icon(LucideIcons.circlePlus),
          ),
      ],
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<PortfolioBloc, PortfolioState>(
        listenWhen: (previous, current) =>
            previous.tab != current.tab ||
            current.loadMoreFailed && !previous.loadMoreFailed ||
            current.authRequired && !previous.authRequired ||
            current.message != null && current.message != previous.message,
        listener: (context, state) {
          portfolioBlocListener(context, state);
        },
        builder: (context, state) {
          final isInitialLoading =
              (state.status == PortfolioStatus.initial ||
                  state.status == PortfolioStatus.loading) &&
              state.items.isEmpty;
          return NotificationListener<ScrollNotification>(
            onNotification: (n) => onScrollNotification(n, context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: buildStories(context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: buildTabs(context, state),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                if (isInitialLoading)
                  SliverToBoxAdapter(child: buildLoadingContent())
                else if (state.status == PortfolioStatus.failure &&
                    state.items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: buildFailureContent(context),
                  )
                else if (state.items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 24),
                      child: buildEmptyContent(context, state),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 24),
                    sliver: SliverList.separated(
                      itemCount:
                          state.items.length + (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 24),
                      itemBuilder: (context, index) =>
                          index == state.items.length
                          ? const Skeletonizer.zone(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Bone.text(words: 4),
                              ),
                            )
                          : buildPostCard(context, state.items[index]),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
