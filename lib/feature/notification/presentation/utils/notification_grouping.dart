import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';

DateTime notificationCalendarDay(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

String notificationTimeLabel(
  AppLocalizations l10n,
  DateTime createdAt, {
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  var at = createdAt.toLocal();
  if (at.isAfter(current)) at = current;
  final diff = current.difference(at);
  if (diff.inMinutes < 1) return l10n.notificationTimeNow;
  if (diff.inHours < 1) return l10n.notificationTimeMinutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return l10n.notificationTimeHoursAgo(diff.inHours);
  return l10n.notificationTimeDaysAgo(diff.inDays);
}

String notificationSectionTitle(
  AppLocalizations l10n,
  DateTime createdAt, {
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final today = notificationCalendarDay(current);
  final day = notificationCalendarDay(createdAt);
  final days = today.difference(day).inDays;
  if (days <= 0) return l10n.notificationSectionToday;
  if (days == 1) return l10n.notificationSectionYesterday;
  if (days < 7) return l10n.notificationSectionDaysAgo(days);
  final weeks = (days / 7).floor().clamp(1, 1 << 20);
  return l10n.notificationSectionWeeksAgo(weeks);
}

List<NotificationSectionModel> groupNotificationItems(
  List<NotificationItemModel> items,
  AppLocalizations l10n, {
  DateTime? now,
}) {
  final grouped = <String, List<NotificationItemModel>>{};
  final order = <String>[];
  for (final item in items) {
    final title = notificationSectionTitle(l10n, item.createdAt, now: now);
    final bucket = grouped.putIfAbsent(title, () {
      order.add(title);
      return <NotificationItemModel>[];
    });
    bucket.add(item);
  }
  return [
    for (final title in order)
      NotificationSectionModel(title: title, items: grouped[title]!),
  ];
}
