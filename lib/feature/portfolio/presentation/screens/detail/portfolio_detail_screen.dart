import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_post_card.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/bloc/portfolio_comments_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/portfolio_comments_sheet.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/detail/bloc/portfolio_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/detail/portfolio_detail_screen_mixin.dart';

class PortfolioDetailScreen extends StatelessWidget {
  const PortfolioDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<PortfolioDetailBloc>()..add(PortfolioDetailStarted(postId)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<PortfolioCommentsBloc>()
                ..add(PortfolioCommentsStarted(postId)),
        ),
      ],
      child: const _PortfolioDetailView(),
    );
  }
}

class _PortfolioDetailView extends StatefulWidget {
  const _PortfolioDetailView();

  @override
  State<_PortfolioDetailView> createState() => _PortfolioDetailViewState();
}

class _PortfolioDetailViewState extends State<_PortfolioDetailView>
    with PortfolioDetailScreenMixin<_PortfolioDetailView> {
  @override
  void initState() {
    super.initState();
    initCommentsInput();
  }

  @override
  void dispose() {
    disposeCommentsInput();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 120) {
      context.read<PortfolioCommentsBloc>().add(
        const PortfolioCommentsLoadMoreRequested(),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: MultiBlocListener(
          listeners: [
            BlocListener<PortfolioDetailBloc, PortfolioDetailState>(
              listenWhen: (previous, current) =>
                  current.authRequired && !previous.authRequired ||
                  current.deleted && !previous.deleted ||
                  current.message != null &&
                      current.message != previous.message,
              listener: portfolioDetailBlocListener,
            ),
            BlocListener<PortfolioCommentsBloc, PortfolioCommentsState>(
              listenWhen: (previous, current) =>
                  current.authRequired && !previous.authRequired ||
                  current.submitted && !previous.submitted ||
                  current.message != null &&
                      current.message != previous.message,
              listener: portfolioCommentsBlocListener,
            ),
          ],
          child: BlocBuilder<PortfolioDetailBloc, PortfolioDetailState>(
            builder: (context, state) {
              final post = state.post;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                    child: Row(
                      children: [
                        AppBackButton.ghost(onTap: () => onBackTap(context)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Portfolio',
                            style: context.textTheme.heading5.copyWith(
                              color: context.appColors.text,
                            ),
                          ),
                        ),
                        // if (post != null)
                        //   IconButton(
                        //     onPressed: () => onDeleteTap(context),
                        //     icon: const Icon(LucideIcons.ellipsis),
                        //   ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: switch (state.status) {
                      PortfolioDetailStatus.failure => TgsFailureContent(
                        message: 'Portfolio ochilmadi. Qayta urinib ko\'ring.',
                        onRetry: () => context.read<PortfolioDetailBloc>().add(
                          const PortfolioDetailRetryRequested(),
                        ),
                      ),
                      PortfolioDetailStatus.loading ||
                      PortfolioDetailStatus.initial =>
                        const PortfolioListSkeleton(),
                      PortfolioDetailStatus.success when post != null =>
                        NotificationListener<ScrollNotification>(
                          onNotification: _onScrollNotification,
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  16,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: PortfolioPostCard(
                                    post: post,
                                    isDetail: true,
                                    onTap: () {},
                                    onLikeTap: () => onLikeTap(context),
                                    onCommentTap: () =>
                                        onCommentTap(context, post),
                                    onShareTap: (shareContext) =>
                                        onShareTap(shareContext, post),
                                    onDeleteTap: () => onDeleteTap(context),
                                  ),
                                ),
                              ),
                              BlocBuilder<
                                PortfolioCommentsBloc,
                                PortfolioCommentsState
                              >(
                                builder: (context, commentsState) {
                                  if (commentsState.items.isEmpty) {
                                    if (commentsState.status ==
                                            PortfolioCommentsStatus.loading ||
                                        commentsState.status ==
                                            PortfolioCommentsStatus.initial) {
                                      return SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: Skeletonizer.zone(
                                            child: Column(
                                              children: List.generate(
                                                3,
                                                (index) => Column(
                                                  children: [
                                                    Divider(
                                                      height: 1,
                                                      thickness: 1,
                                                      color: context
                                                          .appColors
                                                          .stroke,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    const Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Bone.circle(size: 32),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Bone.multiText(
                                                            lines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 32,
                                          horizontal: 24,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Hali izoh yo\'q',
                                            style: context
                                                .textTheme
                                                .bodyMediumRegular
                                                .copyWith(
                                                  color: context
                                                      .appColors
                                                      .secondaryGrey,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          if (index == 0) {
                                            return Divider(
                                              height: 1,
                                              thickness: 1,
                                              color: context.appColors.stroke,
                                            );
                                          }
                                          final commentIndex = index - 1;
                                          if (commentIndex >=
                                              commentsState.items.length) {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                          final comment =
                                              commentsState.items[commentIndex];
                                          return Column(
                                            children: [
                                              const SizedBox(height: 16),
                                              PortfolioCommentTile(
                                                comment: comment,
                                                replies:
                                                    commentsState
                                                        .repliesByCommentId[comment
                                                        .id] ??
                                                    const [],
                                                repliesLoading:
                                                    commentsState
                                                        .replyLoadingCommentId ==
                                                    comment.id,
                                                repliesHasMore:
                                                    commentsState
                                                        .replyHasMoreByCommentId[comment
                                                        .id] ??
                                                    true,
                                                onReplyTap: () =>
                                                    onReplyCommentTap(comment),
                                                onRepliesTap: () =>
                                                    onFetchRepliesRequested(
                                                      context,
                                                      comment.id,
                                                    ),
                                              ),
                                              const SizedBox(height: 16),
                                              Divider(
                                                height: 1,
                                                thickness: 1,
                                                color: context.appColors.stroke,
                                              ),
                                            ],
                                          );
                                        },
                                        childCount:
                                            commentsState.items.length +
                                            1 +
                                            (commentsState.hasMore ? 1 : 0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      _ => const SizedBox.shrink(),
                    },
                  ),
                  if (state.status == PortfolioDetailStatus.success &&
                      post != null)
                    _buildCommentInput(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return BlocBuilder<PortfolioCommentsBloc, PortfolioCommentsState>(
      builder: (context, commentsState) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: context.appColors.stroke, width: 1),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            MediaQuery.paddingOf(context).bottom + 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (replyToComment != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${replyToComment!.author.fullName.isEmpty ? "Foydalanuvchi" : replyToComment!.author.fullName} ga javob',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmallRegular.copyWith(
                            color: context.appColors.secondaryGrey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onCancelReplyTap,
                        child: const Text('Bekor qilish'),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 1000,
                      decoration: const InputDecoration(
                        hintText: 'Izoh yozing',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: commentsState.isSubmitting
                        ? null
                        : () => onCommentSubmit(context),
                    icon: Icon(
                      color: context.appColors.onContainer,
                      commentsState.isSubmitting
                          ? LucideIcons.loader
                          : LucideIcons.send,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
