import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_photo_resolution.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/utils/notification_grouping.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.showDivider,
  });

  final NotificationItemModel item;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isSocial = item.isPostActivity;
    return Column(
      children: [
        Bounce(
          tilt: false,
          onTap: onTap,
          child: Padding(
            padding: AppPadding.paddingHorizontalXl,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSocial)
                  NotificationActorStack(item: item)
                else
                  NotificationLeadingAvatar(photoUrl: item.avatarUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.listText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmallBold.copyWith(
                          color: context.appColors.text,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notificationTimeLabel(context.l10n, item.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmallMedium.copyWith(
                          color: context.appColors.secondaryGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSocial) ...[
                  const SizedBox(width: 8),
                  NotificationPostThumbnail(post: item.post),
                ],
                const SizedBox(width: 8),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: item.isRead ? 0 : 1,
                  child: Container(
                    key: const ValueKey('notification-unread-dot'),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: context.appColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(
              left: isSocial ? 106 : 86,
              top: 14,
              right: AppPadding.paddingHorizontalXl.right,
              bottom: 14,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: context.appColors.stroke,
            ),
          ),
      ],
    );
  }
}

class NotificationLeadingAvatar extends StatelessWidget {
  const NotificationLeadingAvatar({super.key, this.photoUrl, this.size = 48});

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final raw = photoUrl?.trim() ?? '';
    if (raw.isEmpty) return _FlowerFallback(size: size);
    final photo = notificationPhotoRequest(raw);
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: AppCachedNetworkImage(
          imageUrl: photo.url,
          httpHeaders: photo.headers,
          fit: BoxFit.cover,
          placeholder: (ctx, _) => _FlowerFallback(size: size),
          errorWidget: (ctx, url, _) => _FlowerFallback(size: size),
        ),
      ),
    );
  }
}

class NotificationActorStack extends StatelessWidget {
  const NotificationActorStack({super.key, required this.item});

  final NotificationItemModel item;

  @override
  Widget build(BuildContext context) {
    final actors = item.actors.take(2).toList(growable: false);
    return SizedBox(
      key: const ValueKey('notification-actor-stack'),
      width: 68,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (actors.isEmpty)
            const Positioned(
              left: 0,
              top: 10,
              child: NotificationLeadingAvatar(),
            )
          else ...[
            Positioned(
              left: 0,
              top: actors.length > 1 ? 0 : 10,
              child: NotificationLeadingAvatar(photoUrl: actors.first.photoUrl),
            ),
            if (actors.length > 1)
              Positioned(
                left: 20,
                top: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.appColors.background,
                      width: 2,
                    ),
                  ),
                  child: NotificationLeadingAvatar(
                    photoUrl: actors[1].photoUrl,
                  ),
                ),
              ),
          ],
          Positioned(
            right: 0,
            bottom: 0,
            child: _CategoryBadge(category: item.category),
          ),
        ],
      ),
    );
  }
}

class NotificationPostThumbnail extends StatelessWidget {
  const NotificationPostThumbnail({super.key, this.post});

  final NotificationPostModel? post;

  @override
  Widget build(BuildContext context) {
    final url = post?.thumbnailUrl;
    return ClipRRect(
      key: const ValueKey('notification-post-thumbnail'),
      borderRadius: AppRadius.radiusXs,
      child: SizedBox(
        width: 53,
        height: 85,
        child: url == null || url.isEmpty
            ? ColoredBox(
                color: context.appColors.primary.withValues(alpha: 0.12),
                child: Icon(
                  LucideIcons.image,
                  size: 18,
                  color: context.appColors.primary,
                ),
              )
            : Builder(
                builder: (context) {
                  final photo = notificationPhotoRequest(url);
                  return AppCachedNetworkImage(
                    imageUrl: photo.url,
                    httpHeaders: photo.headers,
                    fit: BoxFit.cover,
                    placeholder: (ctx, _) => ColoredBox(
                      color: context.appColors.stroke,
                    ),
                    errorWidget: (ctx, _, _) => ColoredBox(
                      color: context.appColors.primary.withValues(alpha: 0.12),
                      child: Icon(
                        LucideIcons.image,
                        size: 18,
                        color: context.appColors.primary,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final NotificationCategory category;

  @override
  Widget build(BuildContext context) {
    final icon = switch (category) {
      NotificationCategory.postLiked => LucideIcons.heart,
      NotificationCategory.postCommented => LucideIcons.messageCircle,
      NotificationCategory.commentReplied => LucideIcons.cornerDownLeft,
      NotificationCategory.unknown => LucideIcons.bell,
    };
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: context.appColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: context.appColors.background, width: 2),
      ),
      child: Icon(icon, size: 11, color: AppColors.white),
    );
  }
}

class _FlowerFallback extends StatelessWidget {
  const _FlowerFallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.appColors.primary,
      ),
      child: Icon(
        LucideIcons.flower2,
        color: Colors.white,
        size: size * 0.46,
      ),
    );
  }
}
