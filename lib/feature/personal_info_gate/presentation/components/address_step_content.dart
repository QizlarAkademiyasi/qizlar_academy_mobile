import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/bloc/personal_info_gate_bloc.dart';

/// Manzil bosqichi: Mamlakat (O'zbekiston), Viloyat, Tuman, Mahalla DropdownFlutter'lar.
class AddressStepContent extends StatelessWidget {
  const AddressStepContent({super.key});

  CustomDropdownDecoration _decoration(BuildContext context) {
    final colors = context.appColors;
    return CustomDropdownDecoration(
      closedFillColor: colors.onContainer,
      expandedFillColor: colors.onContainer,
      closedBorder: Border.all(color: colors.stroke),
      expandedBorder: Border.all(color: colors.stroke),
      closedBorderRadius: AppRadius.radiusLg,
      expandedBorderRadius: AppRadius.radiusLg,
      hintStyle: context.textTheme.bodyLargeMedium.copyWith(color: colors.secondaryGrey),
      headerStyle: context.textTheme.bodyLargeMedium.copyWith(color: colors.text),
      listItemStyle: context.textTheme.bodyLargeMedium.copyWith(color: colors.text),
      closedSuffixIcon: Icon(LucideIcons.chevronDown, size: 20, color: colors.secondaryGrey),
      expandedSuffixIcon: Icon(LucideIcons.chevronUp, size: 20, color: colors.secondaryGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PersonalInfoGateBloc, PersonalInfoGateState>(
      builder: (context, state) {
        final decoration = _decoration(context);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.personalInfoGateAddressTitle, style: context.textTheme.bodyXLargeSemibold.copyWith(color: context.appColors.text)),
            const SizedBox(height: 4),
            Text(l10n.personalInfoGateAddressSubtitle, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey)),
            const SizedBox(height: 20),

            // Mamlakat — faqat O'zbekiston, o'zgartirib bo'lmaydi
            AppDropdownField(hint: l10n.personalInfoGateCountry, value: "O'zbekiston", enabled: false),
            const SizedBox(height: 12),

            // Viloyat
            DropdownFlutter<RegionModel>(
              hintText: l10n.personalInfoGateRegion,
              items: state.regions,
              initialItem: state.selectedRegion,
              decoration: decoration,
              excludeSelected: false,
              closedHeaderPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              expandedHeaderPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              overlayHeight: 300,
              onChanged: (value) {
                if (value != null) {
                  context.read<PersonalInfoGateBloc>().add(PersonalInfoGateRegionSelected(value));
                }
              },
            ),
            const SizedBox(height: 12),

            // Tuman
            DropdownFlutter<DistrictModel>(
              hintText: l10n.personalInfoGateDistrict,
              items: state.districts,
              initialItem: state.selectedDistrict,
              decoration: decoration,
              excludeSelected: false,
              enabled: state.selectedRegion != null,
              closedHeaderPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              expandedHeaderPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              overlayHeight: 300,
              onChanged: (value) {
                if (value != null) {
                  context.read<PersonalInfoGateBloc>().add(PersonalInfoGateDistrictSelected(value));
                }
              },
            ),
            const SizedBox(height: 12),

            // Mahalla
            DropdownFlutter<NeighborhoodModel>(
              hintText: l10n.personalInfoGateNeighborhood,
              items: state.neighborhoods,
              initialItem: state.selectedNeighborhood,
              decoration: decoration,
              excludeSelected: false,
              enabled: state.selectedDistrict != null,
              closedHeaderPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              expandedHeaderPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              overlayHeight: 300,
              onChanged: (value) {
                if (value != null) {
                  context.read<PersonalInfoGateBloc>().add(PersonalInfoGateNeighborhoodSelected(value));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
