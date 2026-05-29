import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_photo_resolution.dart';

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
    return Column(
      children: [
        Bounce(
          tilt: false,
          onTap: onTap,
          child: Padding(
            padding: AppPadding.paddingHorizontalMd,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _LeadingAvatar(item: item),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmallBold.copyWith(
                              color: context.appColors.text,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.timeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmallMedium.copyWith(
                              color: context.appColors.secondaryGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 160),
                      opacity: item.isRead ? 0 : 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.appColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(
              left: 58,
              top: 14,
              right: AppPadding.paddingHorizontalMd.right,
              bottom: AppPadding.paddingBottomMd.bottom,
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

class _LeadingAvatar extends StatelessWidget {
  const _LeadingAvatar({required this.item});

  final NotificationItemModel item;

  @override
  Widget build(BuildContext context) {
    final raw = item.avatarUrl?.trim() ?? '';
    if (raw.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.appColors.primary,
        ),
        child: const Icon(LucideIcons.flower2, color: Colors.white, size: 22),
      );
    }

    final photo = notificationPhotoRequest(raw);
    return ClipOval(
      child: SizedBox(
        width: 48,
        height: 48,
        child: AppCachedNetworkImage(
          imageUrl: photo.url,
          httpHeaders: photo.headers,
          fit: BoxFit.cover,
          placeholder: (ctx, _) => _placeholder(ctx),
          errorWidget: (ctx, url, _) => _placeholder(ctx),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: context.appColors.primary,
      child: const Icon(LucideIcons.flower2, color: Colors.white, size: 22),
    );
  }
}
