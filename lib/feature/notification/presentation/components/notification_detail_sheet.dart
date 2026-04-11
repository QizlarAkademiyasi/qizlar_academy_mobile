import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_photo_resolution.dart';

Future<void> showNotificationDetailSheet(
  BuildContext context, {
  required NotificationItemModel item,
  required String detailsLabel,
}) {
  return showAppBottomSheet<void>(
    context,
    child: AppBottomSheetContainer(
      showHandle: true,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: _NotificationDetailBody(item: item, detailsLabel: detailsLabel),
    ),
  );
}

Widget _imagePlaceholder(BuildContext context) {
  return ColoredBox(
    color: context.appColors.primary.withValues(alpha: 0.15),
    child: Icon(
      LucideIcons.flower2,
      size: 48,
      color: context.appColors.primary,
    ),
  );
}

class _NotificationDetailBody extends StatelessWidget {
  const _NotificationDetailBody({
    required this.item,
    required this.detailsLabel,
  });

  final NotificationItemModel item;
  final String detailsLabel;

  @override
  Widget build(BuildContext context) {
    final photo = notificationPhotoRequest(item.avatarUrl);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: AppRadius.radiusLg,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: photo.url.isEmpty
                ? ColoredBox(
                    color: context.appColors.primary.withValues(alpha: 0.15),
                    child: Icon(
                      LucideIcons.flower2,
                      size: 48,
                      color: context.appColors.primary,
                    ),
                  )
                : AppCachedNetworkImage(
                    imageUrl: photo.url,
                    httpHeaders: photo.headers,
                    fit: BoxFit.cover,
                    placeholder: (ctx, _) => _imagePlaceholder(ctx),
                    errorWidget: (ctx, url, _) => _imagePlaceholder(ctx),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          item.title,
          style: context.textTheme.bodyXLargeSemibold.copyWith(
            color: context.appColors.text,
          ),
        ),
        if (item.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            item.description,
            style: context.textTheme.bodyMediumRegular.copyWith(
              color: context.appColors.grey,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 20),
        PrimaryButton.elevated(
          label: detailsLabel,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
