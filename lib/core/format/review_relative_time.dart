import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations.dart';

/// Sharh va boshqa joylarda nisbiy vaqt matni (l10n).
String reviewRelativeTimeLabel(AppLocalizations l10n, DateTime? at) {
  if (at == null) return '';
  final now = DateTime.now();
  var d = at;
  if (d.isAfter(now)) d = now;
  final diff = now.difference(d);
  final days = diff.inDays;
  if (days >= 365) {
    final y = days ~/ 365;
    return l10n.reviewTimeYearsAgo(y);
  }
  if (days >= 30) {
    final m = days ~/ 30;
    return l10n.reviewTimeMonthsAgo(m);
  }
  if (days >= 7) {
    final w = days ~/ 7;
    return l10n.reviewTimeWeeksAgo(w);
  }
  if (days >= 1) {
    return l10n.reviewTimeDaysAgo(days);
  }
  final h = diff.inHours;
  if (h >= 1) {
    return l10n.reviewTimeHoursAgo(h);
  }
  final min = diff.inMinutes;
  if (min >= 1) {
    return l10n.reviewTimeMinutesAgo(min);
  }
  return l10n.reviewTimeJustNow;
}
