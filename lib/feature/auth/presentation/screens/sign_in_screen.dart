import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/components/sign_in_phone_field.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/sign_in_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/sheets/privacy_policy_modal_sheet.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SignInScreenMixin<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;
  bool _isSendingOtp = false;
  bool _isGoogleSigningIn = false;
  bool _isTelegramSigningIn = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    final onlyDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final isValid = onlyDigits.length == SignInPhoneField.nationalDigitsLength;
    if (_isPhoneValid == isValid) return;
    setState(() => _isPhoneValid = isValid);
  }

  Future<void> _onStartTap() async {
    if (_isSendingOtp) return;
    setState(() => _isSendingOtp = true);
    try {
      await onSignInTap(localPhone: _phoneController.text);
    } finally {
      if (mounted) {
        setState(() => _isSendingOtp = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleSigningIn) return;
    setState(() => _isGoogleSigningIn = true);
    try {
      await onGoogleTap();
    } finally {
      if (mounted) {
        setState(() => _isGoogleSigningIn = false);
      }
    }
  }

  Future<void> _handleTelegramSignIn() async {
    if (_isTelegramSigningIn) return;
    setState(() => _isTelegramSigningIn = true);
    try {
      await onTelegramTap(localPhone: _phoneController.text);
    } finally {
      if (mounted) {
        setState(() => _isTelegramSigningIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.appColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              primary: false,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              padding: EdgeInsets.fromLTRB(20, 8, 20, 16 + bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildBackButton(context),
                          const SizedBox(height: 24),
                          Text(context.l10n.signInTitle, style: context.textTheme.heading3.copyWith(color: context.appColors.text)),
                          const SizedBox(height: 8),
                          Text(context.l10n.signInSubtitle, style: context.textTheme.bodyMediumMedium.copyWith(color: context.appColors.secondaryGrey)),
                          const SizedBox(height: 22),
                          buildPhoneField(context, controller: _phoneController, onChanged: _onPhoneChanged),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 24),
                        PrimaryButton.elevated(label: context.l10n.signInStart, onPressed: (_isPhoneValid && !_isSendingOtp) ? _onStartTap : null, isLoading: _isSendingOtp),
                        const SizedBox(height: 18),
                        _buildOrDivider(context),
                        const SizedBox(height: 18),
                        buildGoogleButton(context, isLoading: _isGoogleSigningIn, onPressed: _handleGoogleSignIn),
                        const SizedBox(height: 12),
                        buildTelegramButton(context, isLoading: _isTelegramSigningIn, onPressed: !_isTelegramSigningIn ? _handleTelegramSignIn : null),
                        const SizedBox(height: 16),
                        _buildTerms(context),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBackTap,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Icon(LucideIcons.chevronLeft, color: context.appColors.text),
        ),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.appColors.stroke, thickness: 1)),
        const SizedBox(width: 12),
        Text(context.l10n.orDivider, style: context.textTheme.bodyMediumMedium.copyWith(color: context.appColors.secondaryGrey)),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: context.appColors.stroke, thickness: 1)),
      ],
    );
  }

  Widget _buildTerms(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 2,
        children: [
          Text(context.l10n.termsPrefix, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey)),
          PrimaryButton.text(
            label: context.l10n.termsLink,
            onPressed: () => showPrivacyPolicyModalSheet(context),
            height: 24,
            // padding: EdgeInsets.zero,
            textStyle: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.primary),
          ),
          Text(context.l10n.termsSuffix, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey)),
        ],
      ),
    );
  }
}
