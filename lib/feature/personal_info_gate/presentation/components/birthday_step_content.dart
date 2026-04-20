import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/bloc/personal_info_gate_bloc.dart';

/// Tug'ilgan sana bosqichi: sana tanlash maydoni.
class BirthdayStepContent extends StatelessWidget {
  const BirthdayStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    return BlocBuilder<PersonalInfoGateBloc, PersonalInfoGateState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.personalInfoGatePersonalInfoTitle,
              style: context.textTheme.bodyXLargeSemibold.copyWith(
                color: context.appColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.personalInfoGatePersonalInfoSubtitle,
              style: context.textTheme.bodyMediumRegular.copyWith(
                color: context.appColors.secondaryGrey,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppSpinnerDatePickerField(
                hint: l10n.personalInfoGateBirthday,
                value: state.birthday,
                firstDate: DateTime(1950),
                lastDate: now,
                initTimeWhenValueNull: DateTime(
                  now.year - 16,
                  now.month,
                  now.day,
                ),
                onDateSelected: (date) {
                  context.read<PersonalInfoGateBloc>().add(
                    PersonalInfoGateBirthdaySelected(date),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
