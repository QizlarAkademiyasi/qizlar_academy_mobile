import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class SignInPhoneField extends StatelessWidget {
  const SignInPhoneField({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '+998',
            style: context.textTheme.bodyLargeMedium.copyWith(
              color: context.appColors.secondaryGrey,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: context.appColors.stroke),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              style: context.textTheme.bodyLargeMedium.copyWith(
                color: context.appColors.text,
              ),
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'XX XXX XX XX',
                hintStyle: context.textTheme.bodyLargeMedium.copyWith(
                  color: context.appColors.secondaryGrey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
