import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comment_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_comment_input.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/bloc/portfolio_comments_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/portfolio_comments_sheet.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/detail/bloc/portfolio_detail_bloc.dart';

mixin PortfolioDetailScreenMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController commentController;
  PortfolioCommentModel? replyToComment;
  bool isCommentSubmitted = false;

  void initCommentsInput() {
    commentController = TextEditingController();
  }

  void disposeCommentsInput() {
    commentController.dispose();
  }

  void onReplyCommentTap(PortfolioCommentModel comment) {
    setState(() {
      replyToComment = comment;
    });
  }

  void onCancelReplyTap() {
    setState(() {
      replyToComment = null;
    });
  }

  void onFetchRepliesRequested(BuildContext context, String commentId) {
    context.read<PortfolioCommentsBloc>().add(
      PortfolioRepliesRequested(commentId),
    );
  }

  void onCommentSubmit(BuildContext context) {
    final text = commentController.text.trim();
    if (text.isEmpty) return;
    context.read<PortfolioCommentsBloc>().add(
      PortfolioCommentSubmitted(content: text, parentId: replyToComment?.id),
    );
  }

  Widget buildCommentInput(BuildContext context, {required bool isSubmitting}) {
    final authorName = replyToComment?.author.fullName.trim();

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: context.appColors.stroke, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      child: PortfolioCommentInput(
        controller: commentController,
        isSubmitting: isSubmitting,
        onSubmit: () => onCommentSubmit(context),
        replyToName: replyToComment == null
            ? null
            : authorName == null || authorName.isEmpty
            ? 'Foydalanuvchi'
            : authorName,
        onCancelReply: onCancelReplyTap,
      ),
    );
  }

  void portfolioDetailBlocListener(
    BuildContext context,
    PortfolioDetailState state,
  ) {
    if (state.authRequired) {
      AppToast.info(context, message: 'Davom etish uchun tizimga kiring');
      context.read<PortfolioDetailBloc>().add(
        const PortfolioDetailAuthRequiredConsumed(),
      );
      context.push(Routes.signIn);
    }
    final message = state.message;
    if (message != null && message.isNotEmpty) {
      AppToast.error(context, message: message);
    }
    if (state.deleted) {
      AppToast.success(context, message: 'Portfolio o\'chirildi');
      context.pop(true);
    }
  }

  void portfolioCommentsBlocListener(
    BuildContext context,
    PortfolioCommentsState state,
  ) {
    if (state.authRequired) {
      AppToast.info(context, message: 'Izoh yozish uchun tizimga kiring');
      context.read<PortfolioCommentsBloc>().add(
        const PortfolioCommentsAuthRequiredConsumed(),
      );
      context.push(Routes.signIn);
    }
    if (state.submitted) {
      isCommentSubmitted = true;
      commentController.clear();
      setState(() => replyToComment = null);
      // We also trigger a reload of details/post to update the comments count!
      context.read<PortfolioDetailBloc>().add(
        const PortfolioDetailRetryRequested(),
      );
    }
    final message = state.message;
    if (message != null && message.isNotEmpty) {
      AppToast.error(context, message: message);
    }
  }

  void onBackTap(BuildContext context) {
    Gaimon.light();
    context.pop(isCommentSubmitted);
  }

  void onLikeTap(BuildContext context) {
    Gaimon.light();
    context.read<PortfolioDetailBloc>().add(
      const PortfolioDetailLikeRequested(),
    );
  }

  Future<void> onShareTap(PortfolioPostModel post) async {
    Gaimon.light();
    final text = post.caption.trim().isEmpty
        ? 'Qizlar Akademiyasi portfolio'
        : post.caption.trim();
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> onDeleteTap(BuildContext context) async {
    Gaimon.light();
    final confirmed = await showAppPrimaryConfirmDialog(
      context,
      title: 'Portfolio o\'chirilsinmi?',
      description: 'Bu post lentadan o\'chiriladi. Amalni qaytarib bo\'lmaydi.',
      cancelLabel: 'Bekor qilish',
      confirmLabel: 'O\'chirish',
    );
    if (!context.mounted || confirmed != true) return;
    context.read<PortfolioDetailBloc>().add(
      const PortfolioDetailDeleteRequested(),
    );
  }

  Future<void> onCommentTap(
    BuildContext context,
    PortfolioPostModel post,
  ) async {
    Gaimon.light();
    final added = await showPortfolioCommentsSheet(context, postId: post.id);
    if (!context.mounted) return;
    if (added == true) {
      context.read<PortfolioDetailBloc>().add(
        const PortfolioDetailCommentAdded(),
      );
    }
  }
}
