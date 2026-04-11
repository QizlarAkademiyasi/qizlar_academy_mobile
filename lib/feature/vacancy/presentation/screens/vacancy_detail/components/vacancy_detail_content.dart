import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/components/vacancy_detail_section_header.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/utils/vacancy_formatting.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/utils/vacancy_visuals.dart';

class VacancyDetailContent extends StatelessWidget {
  const VacancyDetailContent({super.key, required this.detail});

  final VacancyDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final salaryMain = VacancyFormatting.salaryCardAmountsLine(l10n, detail, localeName: localeName);
    final isNegotiable = detail.salaryFrom <= 0 && detail.salaryTo <= 0;
    final typeLabel = VacancyFormatting.employmentTypeLabel(l10n, detail.type);
    final reqs = VacancyFormatting.requirementBulletItems(detail.requirements);
    final metaParts = <String>[if (typeLabel.trim().isNotEmpty && typeLabel != '—') typeLabel, if (detail.location.trim().isNotEmpty) detail.location.trim()];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: vacancyCardTopTint(detail.id), borderRadius: AppRadius.radiusXl),
              alignment: Alignment.center,
              child: Icon(vacancyCategoryIcon(detail.category), size: 40, color: context.appColors.text),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            detail.title.trim().isEmpty ? '—' : detail.title.trim(),
            textAlign: TextAlign.center,
            style: context.textTheme.heading5.copyWith(color: context.appColors.text, height: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            detail.companyName.trim().isEmpty ? '—' : detail.companyName.trim(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLargeSemibold.copyWith(color: AppColors.primary),
          ),
          if (metaParts.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              metaParts.join(' · '),
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey),
            ),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.vacancySheetSalary, style: context.textTheme.bodyMediumMedium.copyWith(color: context.appColors.secondaryGrey)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(salaryMain, style: context.textTheme.heading4.copyWith(color: context.appColors.text, height: 1.15)),
                    ),
                    if (!isNegotiable) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(l10n.vacancySalaryPerMonth, style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey)),
                            if (VacancyFormatting.salaryCardCurrencyLine(detail).isNotEmpty)
                              Text(VacancyFormatting.salaryCardCurrencyLine(detail), style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (detail.description.trim().isNotEmpty) ...[
            const SizedBox(height: 24),
            VacancyDetailSectionHeader(title: l10n.vacancyDetailAbout),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(color: context.appColors.stroke),
              ),
              child: Text(detail.description.trim(), style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.text, height: 1.45)),
            ),
          ],
          if (detail.skills.isNotEmpty) ...[
            const SizedBox(height: 24),
            VacancyDetailSectionHeader(title: l10n.vacancyDetailSkills),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: detail.skills
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.appColors.onContainer,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: context.appColors.stroke),
                      ),
                      child: Text(s.name.trim().isEmpty ? s.id : s.name.trim(), style: context.textTheme.bodySmallSemibold.copyWith(color: context.appColors.text)),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (reqs.isNotEmpty) ...[
            const SizedBox(height: 24),
            VacancyDetailSectionHeader(title: l10n.vacancyDetailRequirements),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(color: context.appColors.stroke),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < reqs.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: i < reqs.length - 1 ? 12 : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(LucideIcons.circleCheck, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(reqs[i], style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.text, height: 1.4)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
