import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_item_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/utils/vacancy_formatting.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/utils/vacancy_visuals.dart';

class VacancyCard extends StatelessWidget {
  const VacancyCard({super.key, required this.item, required this.onDetailTap});

  final VacancyItemModel item;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final topTint = vacancyCardTopTint(item.id);
    final categoryIcon = vacancyCategoryIcon(item.category);
    final typeLabel = VacancyFormatting.employmentTypeLabel(l10n, item.type);
    final salaryText = VacancyFormatting.salaryLine(l10n, item, localeName: localeName);
    final posted = VacancyFormatting.relativePosted(l10n, item.createdAt);
    final locationText = item.location.trim().isEmpty ? '—' : item.location.trim();

    return Bounce(
      tilt: false,
      onTap: onDetailTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          boxShadow: [BoxShadow(color: AppColors.shadow.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
          border: Border.all(color: context.appColors.stroke),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppPadding.paddingXs,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              decoration: BoxDecoration(color: topTint, borderRadius: AppRadius.radiusMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: context.appColors.bigOpacity.withValues(alpha: 0.4), borderRadius: AppRadius.radiusSm),
                        alignment: Alignment.center,
                        child: Icon(categoryIcon, size: 24, color: context.appColors.text),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title.trim().isEmpty ? '—' : item.title.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.heading6.copyWith(color: context.appColors.text),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.companyName.trim().isEmpty ? '—' : item.companyName.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 1, color: context.appColors.secondaryGrey.withValues(alpha: 0.2)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(LucideIcons.clock, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                typeLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                locationText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salaryText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text),
                      ),
                      const SizedBox(height: 6),
                      Text(posted, style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  height: 38,
                  child: PrimaryButton.elevated(
                    label: l10n.vacancyDetailCta,
                    textStyle: context.textTheme.bodyMediumBold.copyWith(color: AppColors.white),
                    padding: EdgeInsets.zero,
                    expand: true,
                    shape: AppPrimaryButtonShape.roundedRectangle,
                    borderRadius: AppRadius.radius4xl,
                    onPressed: onDetailTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
