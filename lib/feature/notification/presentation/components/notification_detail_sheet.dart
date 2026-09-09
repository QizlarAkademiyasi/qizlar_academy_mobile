import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_photo_resolution.dart';

Future<void> showNotificationDetailSheet(
  BuildContext context, {
  required NotificationItemModel item,
  required VoidCallback onCta,
}) {
  return showAppBottomSheet<void>(
    context,
    child: NotificationDetailSheet(item: item, onCta: onCta),
  );
}

class NotificationDetailSheet extends StatelessWidget {
  const NotificationDetailSheet({
    super.key,
    required this.item,
    required this.onCta,
  });

  final NotificationItemModel item;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    final photo = notificationPhotoRequest(item.avatarUrl);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.background,
          borderRadius: AppRadius.radiusXl,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.appColors.primary.withValues(alpha: 0.16),
              context.appColors.background,
            ],
            stops: const [0, 0.28],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            12 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.appColors.text.withValues(alpha: 0.35),
                    borderRadius: AppRadius.radius2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: AppRadius.radiusMd,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: photo.url.isEmpty
                      ? _imagePlaceholder(context)
                      : AppCachedNetworkImage(
                          imageUrl: photo.url,
                          httpHeaders: photo.headers,
                          fit: BoxFit.cover,
                          placeholder: (ctx, _) => _imagePlaceholder(ctx),
                          errorWidget: (ctx, url, _) =>
                              _imagePlaceholder(ctx),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyXLargeSemibold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMediumRegular.copyWith(
                    color: context.appColors.grey,
                    height: 1.45,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              PrimaryButton.elevated(
                label: context.l10n.notificationDetailsMore,
                height: 52,
                onPressed: onCta,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
