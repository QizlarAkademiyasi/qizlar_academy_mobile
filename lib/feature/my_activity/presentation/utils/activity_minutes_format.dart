import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations.dart';

/// `/activity/stats` qiymatlari daqiqada — UI uchun matnga.
abstract final class ActivityMinutesFormat {
  static String label(AppLocalizations l10n, int minutes) {
    if (minutes <= 0) {
      return l10n.activityDurationMinutes(0);
    }
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) {
      return l10n.activityDurationMinutes(m);
    }
    if (m == 0) {
      return l10n.activityDurationHours(h);
    }
    return l10n.activityDurationHoursMinutes(h, m);
  }

  static String weeklyRangeLabel(DateTime today) {
    final date = DateTime(today.year, today.month, today.day);
    final monday = date.subtract(
      Duration(days: date.weekday - DateTime.monday),
    );
    final sunday = monday.add(const Duration(days: 6));
    final fmt = DateFormat('dd.MM');
    return '${fmt.format(monday)}-${fmt.format(sunday)}';
  }

  static String monthHeading(BuildContext context, DateTime month) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat('yyyy, MMMM', locale).format(month);
  }
}
