import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';

enum AnnouncementSheetAction { open }

Future<AnnouncementSheetAction?> showAnnouncementBottomSheet(
  BuildContext context,
  AnnouncementModel announcement,
) {
  return showAppBottomSheet<AnnouncementSheetAction>(
    context,
    useSafeArea: true,
    child: AnnouncementBottomSheet(announcement: announcement),
  );
}

class AnnouncementBottomSheet extends StatelessWidget {
  const AnnouncementBottomSheet({super.key, required this.announcement});

  final AnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = math.max(32.0, MediaQuery.paddingOf(context).bottom);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusXl,
              border: Border.all(color: context.appColors.stroke),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -6),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: AppRadius.radiusXl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AnnouncementBannerImage(announcement: announcement),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: PrimaryButton.elevated(
                      key: const ValueKey('announcement-cta'),
                      label: _actionLabel(context),
                      height: 52,
                      applyTabletMaxWidth: false,
                      shape: AppPrimaryButtonShape.roundedRectangle,
                      borderRadius: AppRadius.radiusXl,
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(AnnouncementSheetAction.open),
                    ),
                  ),
                  SizedBox(height: bottomPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _actionLabel(BuildContext context) {
    if (announcement.type == AnnouncementType.social) {
      return context.l10n.announcementSocialAction;
    }
    final courseName = announcement.courseName?.trim() ?? '';
    if (courseName.isEmpty) return context.l10n.announcementCourseAction;
    return context.l10n.announcementNamedCourseAction(courseName);
  }
}

class _AnnouncementBannerImage extends StatelessWidget {
  const _AnnouncementBannerImage({required this.announcement});

  final AnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 374 / 439,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: context.appColors.secondaryGrey,
            child: announcement.photoUrl.isEmpty
                ? _fallback(context)
                : AppCachedNetworkImage(
                    imageUrl: announcement.photoUrl,
                    fit: BoxFit.cover,
                    fallback: const AppNetworkImageFallbackCourse(iconSize: 52),
                  ),
          ),
          Positioned(
            top: 13,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Tooltip(
              message: MaterialLocalizations.of(context).closeButtonTooltip,
              child: Material(
                color: const Color(0xFF1E1E1E).withValues(alpha: 0.4),
                shape: const CircleBorder(),
                child: InkWell(
                  key: const ValueKey('announcement-close'),
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox.square(
                    dimension: 34,
                    child: Icon(LucideIcons.x, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    return Center(
      child: Icon(
        announcement.type == AnnouncementType.course
            ? LucideIcons.bookOpen
            : LucideIcons.send,
        size: 52,
        color: Colors.white,
      ),
    );
  }
}
