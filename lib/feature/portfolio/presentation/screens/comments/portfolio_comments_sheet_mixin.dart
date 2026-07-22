import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comment_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_comment_input.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/bloc/portfolio_comments_bloc.dart';

mixin PortfolioCommentsSheetMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController commentController;
  PortfolioCommentModel? replyToComment;
  bool isCommentSubmitted = false;

  void initCommentInput() {
    commentController = TextEditingController();
  }

  void disposeCommentInput() {
    commentController.dispose();
  }

  bool onCommentsScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 120) {
      context.read<PortfolioCommentsBloc>().add(
        const PortfolioCommentsLoadMoreRequested(),
      );
    }
    return false;
  }

  void onCommentSubmit(BuildContext context) {
    final text = commentController.text.trim();
    if (text.isEmpty) return;
    context.read<PortfolioCommentsBloc>().add(
      PortfolioCommentSubmitted(content: text, parentId: replyToComment?.id),
    );
  }

  void onReplyTap(PortfolioCommentModel comment) {
    setState(() => replyToComment = comment);
  }

  void onCancelReplyTap() {
    setState(() => replyToComment = null);
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
    }
    final message = state.message;
    if (message != null && message.isNotEmpty) {
      AppToast.error(context, message: message);
    }
  }

  Widget buildCommentInput(BuildContext context, {required bool isSubmitting}) {
    final authorName = replyToComment?.author.fullName.trim();

    return PortfolioCommentInput(
      controller: commentController,
      isSubmitting: isSubmitting,
      onSubmit: () => onCommentSubmit(context),
      replyToName: replyToComment == null
          ? null
          : authorName == null || authorName.isEmpty
          ? 'Foydalanuvchi'
          : authorName,
      onCancelReply: onCancelReplyTap,
    );
  }
}
