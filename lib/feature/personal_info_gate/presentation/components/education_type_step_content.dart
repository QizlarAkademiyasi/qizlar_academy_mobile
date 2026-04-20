import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/config/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/bloc/personal_info_gate_bloc.dart';

/// Tashkilot turi bosqichi: Maktab, Kollej/Litsey, Universitet, Hozir o'qimayman.
class EducationTypeStepContent extends StatelessWidget {
  const EducationTypeStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PersonalInfoGateBloc, PersonalInfoGateState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.personalInfoGateEducationTitle, style: context.textTheme.bodyXLargeSemibold.copyWith(color: context.appColors.text)),
            const SizedBox(height: 4),
            Text(l10n.personalInfoGateEducationSubtitle, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey)),
            const SizedBox(height: 20),
            ...EducationType.values.map(
              (type) => _EducationTypeRadioTile(
                label: type.label,
                isSelected: state.educationType == type,
                onTap: () => context.read<PersonalInfoGateBloc>().add(PersonalInfoGateEducationTypeSelected(type)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EducationTypeRadioTile extends StatelessWidget {
  const _EducationTypeRadioTile({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.textTheme.bodyLargeMedium.copyWith(color: colors.text))),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? colors.primary : colors.stroke, width: 2),
              ),
              child: isSelected
                  ? Center(child: Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primary)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
