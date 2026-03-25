import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

enum SignInSocialProvider { google, telegram }

class SignInSocialButton extends StatelessWidget {
  const SignInSocialButton({
    super.key,
    required this.provider,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final SignInSocialProvider provider;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton.icon(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      leading: _buildIcon(context),
      backgroundColor: context.appColors.onContainer,
      foregroundColor: context.appColors.text,
      borderColor: context.appColors.stroke,
      textStyle: context.textTheme.bodyLargeSemibold.copyWith(
        color: context.appColors.text,
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return switch (provider) {
      SignInSocialProvider.google => Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Text(
          'G',
          style: context.textTheme.bodyMediumBold.copyWith(
            color: const Color(0xFFEA4335),
          ),
        ),
      ),
      SignInSocialProvider.telegram => Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF29A9EA),
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Icon(LucideIcons.send, size: 13, color: AppColors.white),
      ),
    };
  }
}
