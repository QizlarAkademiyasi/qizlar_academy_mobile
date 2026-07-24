import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_post_card.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_share.dart';

mixin PortfolioScreenMixin<T extends StatefulWidget> on State<T> {
  void portfolioBlocListener(BuildContext context, PortfolioState state) {
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
