import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_stories_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_story_bar.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/story_screen.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_post_card.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_share.dart';

mixin PortfolioScreenMixin<T extends StatefulWidget>
    on State<T>, TickerProvider {
  late final TabController portfolioTabController;

  @override
  void initState() {
    super.initState();
    portfolioTabController = TabController(
      length: PortfolioFeedTab.values.length,
      initialIndex: context.read<PortfolioBloc>().state.tab.index,
      vsync: this,
    );
  }

  @override
  void dispose() {
    portfolioTabController.dispose();
    super.dispose();
  }

  bool onScrollNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification is! ScrollUpdateNotification &&
        notification is! OverscrollNotification) {
      return false;
    }
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 240) {
      onScrollNearEnd(context);
    }
    return false;
  }

  Widget buildLoadingContent() => const PortfolioListSkeleton();
  Widget buildFailureContent(BuildContext context) => TgsFailureContent(
    message: 'Portfolio yuklanmadi. Qayta urinib ko\'ring.',
    onRetry: () =>
        context.read<PortfolioBloc>().add(const PortfolioRetryRequested()),
  );
  Widget buildEmptyContent(BuildContext context, PortfolioState state) =>
      PortfolioEmptyContent(
        tab: state.tab,
        isGuest: state.isGuest,
        onCreateTap: state.isGuest ? null : () => onCreateTap(context, state),
      );
  Widget buildTabs(BuildContext context, PortfolioState state) =>
      AppSegmentedTabBar(
        controller: portfolioTabController,
        tabLabels: ['Barchasi', context.l10n.portfolioMineLabel],
        onTap: (index) => onTabChanged(context, PortfolioFeedTab.values[index]),
      );
  Widget buildStories(BuildContext context) =>
      BlocBuilder<PortfolioStoriesBloc, PortfolioStoriesState>(
        builder: (context, state) {
          if (state.status == PortfolioStoriesStatus.failure) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextButton(
                onPressed: () => context.read<PortfolioStoriesBloc>().add(
                  const PortfolioStoriesStarted(),
                ),
                child: Text(context.l10n.portfolioStoriesError),
              ),
            );
          }
          if (state.status == PortfolioStoriesStatus.success &&
              state.items.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: PortfolioStoryBar(
              items: state.items,
              viewedIds: state.viewedIds,
              isLoading:
                  state.status == PortfolioStoriesStatus.initial ||
                  state.status == PortfolioStoriesStatus.loading,
              onTap: (index) => openStory(context, state, index),
            ),
          );
        },
      );
  void openStory(BuildContext context, PortfolioStoriesState state, int index) {
    final bloc = context.read<PortfolioStoriesBloc>();
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, _, _) => StoryScreen(
          categories: state.items,
          initialIndex: index,
          onView: (id) {
            if (!bloc.isClosed) bloc.add(PortfolioStoryViewed(id));
          },
        ),
      ),
    );
  }

  void portfolioBlocListener(BuildContext context, PortfolioState state) {
    if (portfolioTabController.index != state.tab.index) {
      portfolioTabController.animateTo(state.tab.index);
    }
    if (state.loadMoreFailed) {
      AppToast.error(context, message: 'Portfolio yuklashda xatolik yuz berdi');
      context.read<PortfolioBloc>().add(
        const PortfolioLoadMoreFailureConsumed(),
      );
    }
    if (state.authRequired) {
      AppToast.info(context, message: 'Davom etish uchun tizimga kiring');
      context.read<PortfolioBloc>().add(const PortfolioAuthRequiredConsumed());
      context.push(Routes.signIn);
    }
    final message = state.message;
    if (message != null && message.isNotEmpty) {
      AppToast.error(context, message: message);
    }
    if (state.deletedPostId != null) {
      AppToast.success(context, message: 'Portfolio o\'chirildi');
    }
  }

  void onBackTap(BuildContext context) {
    Gaimon.light();
    context.pop();
  }

  void onCreateTap(BuildContext context, PortfolioState state) {
    Gaimon.light();
    if (state.isGuest) {
      AppToast.info(context, message: 'Portfolio joylash uchun tizimga kiring');
      context.push(Routes.signIn);
      return;
    }
    context.push(Routes.portfolioCreate).then((created) {
      if (!context.mounted) return;
      if (created == true) {
        context.read<PortfolioBloc>().add(const PortfolioRetryRequested());
      }
    });
  }

  void onTabChanged(BuildContext context, PortfolioFeedTab tab) {
    context.read<PortfolioBloc>().add(PortfolioTabChanged(tab));
  }

  void onScrollNearEnd(BuildContext context) {
    context.read<PortfolioBloc>().add(const PortfolioLoadMoreRequested());
  }

  void onPostTap(BuildContext context, PortfolioPostModel post) {
    Gaimon.light();
    context.push(Routes.portfolioDetailPath(post.id)).then((deleted) {
      if (!context.mounted) return;
      if (deleted == true) {
        context.read<PortfolioBloc>().add(PortfolioPostRemovedLocally(post.id));
      }
    });
  }

  void onLikeTap(BuildContext context, PortfolioPostModel post) {
    Gaimon.light();
    context.read<PortfolioBloc>().add(PortfolioLikeRequested(post.id));
  }

  Future<void> onDeleteTap(
    BuildContext context,
    PortfolioPostModel post,
  ) async {
    Gaimon.light();
    final confirmed = await showAppPrimaryConfirmDialog(
      context,
      title: 'Portfolio o\'chirilsinmi?',
      description: 'Bu post lentadan o\'chiriladi. Amalni qaytarib bo\'lmaydi.',
      cancelLabel: 'Bekor qilish',
      confirmLabel: 'O\'chirish',
    );
    if (!context.mounted || confirmed != true) return;
    context.read<PortfolioBloc>().add(PortfolioDeleteRequested(post.id));
  }

  void onCommentTap(BuildContext context, PortfolioPostModel post) {
    onPostTap(context, post);
  }

  Future<void> onShareTap(BuildContext context, PortfolioPostModel post) async {
    Gaimon.light();
    await PortfolioShare.share(context, post);
  }

  Widget buildPostCard(BuildContext context, PortfolioPostModel post) {
    return PortfolioPostCard(
      post: post,
      onTap: () => onPostTap(context, post),
      onLikeTap: () => onLikeTap(context, post),
      onCommentTap: () => onCommentTap(context, post),
      onShareTap: (shareContext) => onShareTap(shareContext, post),
      onDeleteTap: post.isOwnedByCurrentUser
          ? () => onDeleteTap(context, post)
          : null,
    );
  }
}
