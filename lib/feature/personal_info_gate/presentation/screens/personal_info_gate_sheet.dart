import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/bloc/personal_info_gate_bloc.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/components/address_step_content.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/components/birthday_step_content.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/components/education_type_step_content.dart';

/// Bitta bosqich uchun bottom sheet ko'rsatadi.
/// [step]: 0 = Manzil, 1 = Tug'ilgan sana, 2 = Ta'lim turi.
/// "Davom etish" bosilganda shu bosqich PATCH qilinadi va sheet yopiladi.
///
/// Qaytaradi: `true` agar muvaffaqiyatli yuborilsa, aks holda `null`/`false`.
Future<bool?> showPersonalInfoGateSheet(BuildContext context, {required int step}) {
  return showAppBottomSheet<bool>(
    context,
    child: BlocProvider(
      create: (_) => getIt<PersonalInfoGateBloc>()..add(PersonalInfoGateStarted(step: step)),
      child: _PersonalInfoGateSheetBody(step: step),
    ),
  );
}

class _PersonalInfoGateSheetBody extends StatelessWidget {
  const _PersonalInfoGateSheetBody({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<PersonalInfoGateBloc, PersonalInfoGateState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == PersonalInfoGateStatus.success) {
          Navigator.of(context).pop(true);
        }
        if (state.status == PersonalInfoGateStatus.failure) {
          AppToast.error(context, message: l10n.personalInfoGateSubmitError);
        }
      },
      builder: (context, state) {
        if (state.status == PersonalInfoGateStatus.loading) {
          return const AppBottomSheetContainer(
            child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
          );
        }

        return AppBottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStepContent(),
              const SizedBox(height: 20),
              PrimaryButton.elevated(
                label: l10n.personalInfoGateContinue,
                isLoading: state.status == PersonalInfoGateStatus.submitting,
                onPressed: state.canContinue
                    ? () => context.read<PersonalInfoGateBloc>().add(const PersonalInfoGateStepSubmitted())
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case 0:
        return const AddressStepContent();
      case 1:
        return const BirthdayStepContent();
      case 2:
        return const EducationTypeStepContent();
      default:
        return const SizedBox.shrink();
    }
  }
}
