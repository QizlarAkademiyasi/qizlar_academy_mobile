import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations_en.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/utils/notification_grouping.dart';

void main() {
  final l10n = AppLocalizationsEn();
  final now = DateTime(2026, 9, 9, 15);

  NotificationItemModel item(DateTime createdAt) {
    return NotificationItemModel(
      id: createdAt.toIso8601String(),
      title: 't',
      description: 'd',
      createdAt: createdAt,
      channelType: NotificationChannelType.push,
      isRead: true,
    );
  }

  test('groups today yesterday days and weeks', () {
    final sections = groupNotificationItems(
      [
        item(DateTime(2026, 9, 9, 10)),
        item(DateTime(2026, 9, 8, 10)),
        item(DateTime(2026, 9, 6, 10)),
        item(DateTime(2026, 8, 20, 10)),
      ],
      l10n,
      now: now,
    );
    expect(sections.map((s) => s.title).toList(), [
      l10n.notificationSectionToday,
      l10n.notificationSectionYesterday,
      l10n.notificationSectionDaysAgo(3),
      l10n.notificationSectionWeeksAgo(2),
    ]);
  });

  test('builds relative time labels', () {
    expect(
      notificationTimeLabel(l10n, now.subtract(const Duration(seconds: 20)), now: now),
      l10n.notificationTimeNow,
    );
    expect(
      notificationTimeLabel(l10n, now.subtract(const Duration(minutes: 5)), now: now),
      l10n.notificationTimeMinutesAgo(5),
    );
  });
}
