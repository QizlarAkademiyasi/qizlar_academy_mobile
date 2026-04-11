import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class SignInPhoneField extends StatelessWidget {
  const SignInPhoneField({super.key, required this.controller, this.onChanged});

  static const int nationalDigitsLength = 9;

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [
        AutofillHints.telephoneNumberNational,
        AutofillHints.telephoneNumber,
      ],
      hintText: 'XX XXX XX XX',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(nationalDigitsLength),
      ],
      onChanged: onChanged,
      prefix: Text(
        '+998',
        style: context.textTheme.bodyLargeMedium.copyWith(
          color: context.appColors.secondaryGrey,
        ),
      ),
    );
  }
}
