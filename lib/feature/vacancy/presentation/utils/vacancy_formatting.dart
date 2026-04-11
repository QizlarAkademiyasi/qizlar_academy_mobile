import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/generated/app_localizations.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_item_model.dart';

class VacancyFormatting {
  VacancyFormatting._();

  static String employmentTypeLabel(AppLocalizations l10n, String rawType) {
    final t = rawType.trim().toUpperCase();
    switch (t) {
      case 'INTERN':
        return l10n.vacancyEmploymentIntern;
      case 'PART_TIME':
        return l10n.vacancyEmploymentPartTime;
      case 'FULL_TIME':
        return l10n.vacancyEmploymentFullTime;
      case 'REMOTE':
        return l10n.vacancyEmploymentRemote;
      case 'ONSITE':
        return l10n.vacancyEmploymentOnsite;
      case 'CONTRACT':
        return l10n.vacancyEmploymentContract;
      default:
        return rawType.trim().isEmpty ? '—' : rawType.trim();
    }
  }

  static String salaryLine(AppLocalizations l10n, VacancyItemModel v, {required String localeName}) {
    if (v.salaryFrom <= 0 && v.salaryTo <= 0) {
      return l10n.vacancySalaryNegotiable;
    }
    final fmt = NumberFormat.decimalPattern(localeName);
    final from = v.salaryFrom > 0 ? fmt.format(v.salaryFrom) : fmt.format(v.salaryTo);
    final to = v.salaryTo > 0 ? fmt.format(v.salaryTo) : from;
    final cur = v.currency.trim().isEmpty ? 'UZS' : v.currency.trim();
    return l10n.vacancySalaryRange(from, to, cur);
  }

  /// Katta maosh qatori (valyuta alohida kichik qator yoki suffix bilan ko‘rsatiladi).
  static String salaryCardAmountsLine(AppLocalizations l10n, VacancyDetailModel d, {required String localeName}) {
    if (d.salaryFrom <= 0 && d.salaryTo <= 0) {
      return l10n.vacancySalaryNegotiable;
    }
    final fmt = NumberFormat.decimalPattern(localeName);
    final from = d.salaryFrom > 0 ? fmt.format(d.salaryFrom) : fmt.format(d.salaryTo);
    final to = d.salaryTo > 0 ? fmt.format(d.salaryTo) : from;
    return '$from – $to';
  }

  static String salaryCardCurrencyLine(VacancyDetailModel d) {
    final cur = d.currency.trim().isEmpty ? 'UZS' : d.currency.trim();
    return cur;
  }

  /// [requirements] matnini ro‘yxat bandlariga ajratish (yangi qator, bullet, chiziqcha).
  static List<String> requirementBulletItems(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return const [];

    var lines = t.split(RegExp(r'\r?\n')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (lines.length > 1) return lines;

    if (t.contains('•')) {
      final b = t.split('•').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (b.length > 1) return b;
    }

    final dashParts = t.split(RegExp(r'\s*[-*–—]\s+'));
    if (dashParts.length > 1) {
      return dashParts.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    return [t];
  }

  static String relativePosted(AppLocalizations l10n, DateTime createdAt) {
    final now = DateTime.now();
    var diff = now.difference(createdAt);
    if (diff.isNegative) diff = Duration.zero;

    if (diff.inMinutes < 1) {
      return l10n.vacancyPostedMomentsAgo;
    }
    if (diff.inHours < 1) {
      return l10n.vacancyPostedMinutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return l10n.vacancyPostedHoursAgo(diff.inHours);
    }
    if (diff.inHours < 48) {
      return l10n.vacancyPostedYesterday;
    }
    final days = diff.inDays;
    return l10n.vacancyPostedDaysAgo(days < 1 ? 1 : days);
  }
}
