import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Ism, familiya va +998 / milliy qism (faqat ko‘rsatish — PATCH qilinmaydi).
class EditInformationForm extends StatelessWidget {
  const EditInformationForm({super.key, required this.firstNameController, required this.lastNameController, required this.phoneNationalController});

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNationalController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        AppTextField(
          controller: phoneNationalController,
          // labelText: l10n.profileInformationPhoneLabel,
          // hintText: l10n.profileInformationPhoneNationalHint,
          readOnly: true,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          prefix: Text('+998', style: context.textTheme.bodyLargeMedium.copyWith(color: context.appColors.secondaryGrey)),
        ),
      ],
    );
  }
}
