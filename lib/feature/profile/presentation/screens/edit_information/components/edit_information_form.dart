import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/bloc/edit_information_bloc.dart';

/// Ism, familiya, telefon, kasb, tug'ilgan sana, manzil.
class EditInformationForm extends StatelessWidget {
  const EditInformationForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNationalController,
    required this.occupationController,
    required this.state,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNationalController;
  final TextEditingController occupationController;
  final EditInformationState state;

  CustomDropdownDecoration _decoration(BuildContext context) {
    final colors = context.appColors;
    return CustomDropdownDecoration(
      closedFillColor: colors.onContainer,
      expandedFillColor: colors.onContainer,
      closedBorder: Border.all(color: colors.stroke),
      expandedBorder: Border.all(color: colors.stroke),
      closedBorderRadius: AppRadius.radiusLg,
      expandedBorderRadius: AppRadius.radiusLg,
      hintStyle: context.textTheme.bodyLargeMedium.copyWith(
        color: colors.secondaryGrey,
      ),
      headerStyle: context.textTheme.bodyLargeMedium.copyWith(
        color: colors.text,
      ),
      listItemStyle: context.textTheme.bodyLargeMedium.copyWith(
        color: colors.text,
      ),
      closedSuffixIcon: Icon(
        LucideIcons.chevronDown,
        size: 20,
        color: colors.secondaryGrey,
      ),
      expandedSuffixIcon: Icon(
        LucideIcons.chevronUp,
        size: 20,
        color: colors.secondaryGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final decoration = _decoration(context);
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: firstNameController,
          labelText: l10n.firstNameHint,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: lastNameController,
          labelText: l10n.lastNameHint,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        // --- Telefon raqam ---
        Text(
          l10n.profileInformationPersonalTitle,
          style: context.textTheme.bodySmallSemibold.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: phoneNationalController,
          readOnly: true,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          prefix: Text(
            '+998',
            style: context.textTheme.bodyLargeMedium.copyWith(
              color: context.appColors.secondaryGrey,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: occupationController,
          labelText: l10n.profileInformationOccupation,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 16),
        AppSpinnerDatePickerField(
          hint: l10n.profileInformationBirthday,
          value: state.selectedBirthday,
          firstDate: DateTime(1950),
          lastDate: now,
          initTimeWhenValueNull: DateTime(now.year - 16, now.month, now.day),
          onDateSelected: (date) => context.read<EditInformationBloc>().add(
            EditInformationBirthdaySelected(date),
          ),
        ),

        const SizedBox(height: 28),

        // --- Manzil ---
        Text(
          l10n.profileInformationAddressTitle,
          style: context.textTheme.bodySmallSemibold.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
        const SizedBox(height: 10),

        // Viloyat
        DropdownFlutter<RegionModel>(
          hintText: l10n.profileInformationRegion,
          items: state.regions,
          initialItem: state.selectedRegion,
          decoration: decoration,
          excludeSelected: false,
          closedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          expandedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          overlayHeight: 300,
          onChanged: (value) {
            if (value != null) {
              context.read<EditInformationBloc>().add(
                EditInformationRegionSelected(value),
              );
            }
          },
        ),
        const SizedBox(height: 12),

        // Tuman
        DropdownFlutter<DistrictModel>(
          hintText: l10n.profileInformationDistrict,
          items: state.districts,
          initialItem: state.selectedDistrict,
          decoration: decoration,
          excludeSelected: false,
          enabled: state.selectedRegion != null,
          closedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          expandedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          overlayHeight: 300,
          onChanged: (value) {
            if (value != null) {
              context.read<EditInformationBloc>().add(
                EditInformationDistrictSelected(value),
              );
            }
          },
        ),
        const SizedBox(height: 12),

        // Mahalla
        DropdownFlutter<NeighborhoodModel>(
          hintText: l10n.profileInformationNeighborhood,
          items: state.neighborhoods,
          initialItem: state.selectedNeighborhood,
          decoration: decoration,
          excludeSelected: false,
          enabled: state.selectedDistrict != null,
          closedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          expandedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          overlayHeight: 300,
          onChanged: (value) {
            if (value != null) {
              context.read<EditInformationBloc>().add(
                EditInformationNeighborhoodSelected(value),
              );
            }
          },
        ),
      ],
    );
  }
}
