import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_avatar.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_like_button.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_media_preview.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_formatting.dart';

class PortfolioPostCard extends StatelessWidget {
  const PortfolioPostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    this.onDeleteTap,
    this.isDetail = false,
  });

  final PortfolioPostModel post;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final ValueChanged<BuildContext> onShareTap;
  final VoidCallback? onDeleteTap;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    final name = post.author.fullName.isEmpty
        ? 'Qizlar Akademiyasi'
        : post.author.fullName;
    final mediaHeight = isDetail ? 433.0 : 386.0;
    return Material(
      color: context.appColors.onContainer,
      borderRadius: AppRadius.radiusLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isDetail ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostHeader(post: post, name: name, onDeleteTap: onDeleteTap),
              if (post.caption.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  post.caption.trim(),
                  maxLines: isDetail ? null : 3,
                  overflow: isDetail
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: context.textTheme.bodyMediumRegular.copyWith(
                    color: context.appColors.text,
                    height: 1.45,
                  ),
                ),
              ],
              if (post.media.isNotEmpty) ...[
                const SizedBox(height: 12),
                PortfolioMediaPreview(media: post.media, height: mediaHeight),
              ],
              if (isDetail) ...[
                const SizedBox(height: 10),
                _DetailMeta(post: post),
              ],
              const SizedBox(height: 10),
              Divider(height: 1, thickness: 1, color: context.appColors.stroke),
              const SizedBox(height: 8),
              if (isDetail)
                Row(
                  children: [
                    PortfolioLikeButton(
                      isLiked: post.isLiked,
                      onTap: onLikeTap,
                      likesCount: post.likesCount,
                      iconSize: 20,
                    ),
                    const Spacer(),
                    _PostShareButton(iconSize: 20, onTap: onShareTap),
                  ],
                )
              else
                Row(
                  children: [
                    _ActionCounter(
                      icon: LucideIcons.messageCircle,
                      value: post.commentsCount,
                      onTap: onCommentTap,
                    ),
                    const SizedBox(width: 24),
                    PortfolioLikeButton(
                      isLiked: post.isLiked,
                      likesCount: post.likesCount,
                      onTap: onLikeTap,
                    ),
                    const Spacer(),
                    _PostShareButton(iconSize: 16, onTap: onShareTap),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.post,
    required this.name,
    required this.onDeleteTap,
  });

  final PortfolioPostModel post;
  final String name;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioAvatar(photoUrl: post.author.photoUrl, name: name, size: 40),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                PortfolioFormatting.relativeTime(post.createdAt),
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: context.appColors.secondaryGrey,
                ),
              ),
            ],
          ),
        ),
        if (onDeleteTap != null)
          InkWell(
            onTap: onDeleteTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                LucideIcons.ellipsis,
                size: 20,
                color: context.appColors.grey,
              ),
            ),
          ),
      ],
    );
  }
}

class _PostShareButton extends StatelessWidget {
  const _PostShareButton({required this.iconSize, required this.onTap});

  final double iconSize;
  final ValueChanged<BuildContext> onTap;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (shareContext) => Tooltip(
        message: context.l10n.portfolioShareTooltip,
        child: InkWell(
          onTap: () => onTap(shareContext),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              LucideIcons.share2,
              size: iconSize,
              color: context.appColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailMeta extends StatelessWidget {
  const _DetailMeta({required this.post});

  final PortfolioPostModel post;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodySmallRegular.copyWith(
      color: context.appColors.secondaryGrey,
    );
    final values = <String>[
      PortfolioFormatting.detailTime(post.createdAt),
      PortfolioFormatting.detailDate(post.createdAt),
      '${PortfolioFormatting.compactCount(post.viewsCount)} ko\'rganlar',
      '${PortfolioFormatting.compactCount(post.likesCount)} yoqtirganlar',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < values.length; index++)
          Text(index == 0 ? values[index] : '• ${values[index]}', style: style),
      ],
    );
  }
}

class _ActionCounter extends StatelessWidget {
  const _ActionCounter({
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = context.appColors.grey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: effectiveColor),
            const SizedBox(width: 4),
            Text(
              PortfolioFormatting.compactCount(value),
              style: context.textTheme.bodySmallRegular.copyWith(
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
