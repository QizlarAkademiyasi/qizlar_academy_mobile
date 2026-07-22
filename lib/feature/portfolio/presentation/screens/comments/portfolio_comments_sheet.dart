import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comment_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_avatar.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/bloc/portfolio_comments_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/portfolio_comments_sheet_mixin.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_formatting.dart';

Future<bool?> showPortfolioCommentsSheet(
  BuildContext context, {
  required String postId,
}) {
  return showAppBottomSheet<bool>(
    context,
    child: BlocProvider(
      create: (_) =>
          getIt<PortfolioCommentsBloc>()..add(PortfolioCommentsStarted(postId)),
      child: const PortfolioCommentsSheet(),
    ),
  );
}

class PortfolioCommentsSheet extends StatefulWidget {
  const PortfolioCommentsSheet({super.key});

  @override
  State<PortfolioCommentsSheet> createState() => _PortfolioCommentsSheetState();
}

class _PortfolioCommentsSheetState extends State<PortfolioCommentsSheet>
    with PortfolioCommentsSheetMixin<PortfolioCommentsSheet> {
  @override
  void initState() {
    super.initState();
    initCommentInput();
  }

  @override
  void dispose() {
    disposeCommentInput();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
      },
      child: AppBottomSheetContainer(
        child: BlocConsumer<PortfolioCommentsBloc, PortfolioCommentsState>(
          listenWhen: (previous, current) =>
              previous.authRequired != current.authRequired ||
              previous.submitted != current.submitted ||
              previous.message != current.message,
          listener: portfolioCommentsBlocListener,
          builder: (context, state) {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.78,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Izohlar',
                          style: context.textTheme.heading6.copyWith(
                            color: context.appColors.text,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            Navigator.of(context).pop(isCommentSubmitted),
                        icon: const Icon(LucideIcons.x),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: switch (state.status) {
                      PortfolioCommentsStatus.failure => TgsFailureContent(
                        message: 'Izohlar yuklanmadi. Qayta urinib ko\'ring.',
                        onRetry: () => context
                            .read<PortfolioCommentsBloc>()
                            .add(const PortfolioCommentsRetryRequested()),
                      ),
                      PortfolioCommentsStatus.loading ||
                      PortfolioCommentsStatus.initial => Skeletonizer.zone(
                        child: ListView.separated(
                          itemCount: 5,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 16),
                          itemBuilder: (_, _) => const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Bone.circle(size: 32),
                              SizedBox(width: 10),
                              Expanded(child: Bone.multiText(lines: 2)),
                            ],
                          ),
                        ),
                      ),
                      PortfolioCommentsStatus.success
                          when state.items.isEmpty =>
                        const Center(
                          child: TgsEmptyContent(
                            message: 'Hali izoh yo\'q',
                            subtitle: 'Birinchi izohni siz yozishingiz mumkin.',
                          ),
                        ),
                      _ => NotificationListener<ScrollNotification>(
                        onNotification: onCommentsScroll,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount:
                              state.items.length +
                              (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            if (index >= state.items.length) {
                              return Skeletonizer.zone(
                                child: const Bone.text(words: 4),
                              );
                            }
                            final comment = state.items[index];
                            return PortfolioCommentTile(
                              comment: comment,
                              replies:
                                  state.repliesByCommentId[comment.id] ??
                                  const [],
                              repliesLoading:
                                  state.replyLoadingCommentId == comment.id,
                              repliesHasMore:
                                  state.replyHasMoreByCommentId[comment.id] ??
                                  true,
                              onReplyTap: () => onReplyTap(comment),
                              onRepliesTap: () => context
                                  .read<PortfolioCommentsBloc>()
                                  .add(PortfolioRepliesRequested(comment.id)),
                            );
                          },
                        ),
                      ),
                    },
                  ),
                  buildCommentInput(context, isSubmitting: state.isSubmitting),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PortfolioCommentTile extends StatelessWidget {
  const PortfolioCommentTile({
    super.key,
    required this.comment,
    required this.replies,
    required this.repliesLoading,
    required this.repliesHasMore,
    required this.onReplyTap,
    required this.onRepliesTap,
  });

  final PortfolioCommentModel comment;
  final List<PortfolioCommentModel> replies;
  final bool repliesLoading;
  final bool repliesHasMore;
  final VoidCallback onReplyTap;
  final VoidCallback onRepliesTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioCommentContent(comment: comment, onReplyTap: onReplyTap),
        // Vaqtinchalik reply yashirildi
        /* if (replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 42, top: 12),
            child: Column(
              children: [
                for (final reply in replies)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PortfolioCommentContent(
                      comment: reply,
                      onReplyTap: onReplyTap,
                    ),
                  ),
              ],
            ),
          ),
        if (repliesLoading && replies.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 42, top: 8),
            child: Skeletonizer.zone(child: Bone.text(words: 3)),
          ), */
      ],
    );
  }
}

class PortfolioCommentContent extends StatelessWidget {
  const PortfolioCommentContent({
    super.key,
    required this.comment,
    required this.onReplyTap,
  });

  final PortfolioCommentModel comment;
  final VoidCallback onReplyTap;

  @override
  Widget build(BuildContext context) {
    final authorName = comment.author.fullName.isEmpty
        ? 'Foydalanuvchi'
        : comment.author.fullName;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioAvatar(
          photoUrl: comment.author.photoUrl,
          name: authorName,
          size: 32,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMediumBold.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                  ),
                  Text(
                    PortfolioFormatting.relativeTime(comment.createdAt),
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment.content,
                style: context.textTheme.bodyMediumRegular.copyWith(
                  color: context.appColors.text,
                ),
              ),
              // Vaqtinchalik javob yozish tugmasi olib tashlandi
              /* TextButton(
                onPressed: onReplyTap,
                child: const Text('Javob yozish'),
              ), */
            ],
          ),
        ),
      ],
    );
  }
}
