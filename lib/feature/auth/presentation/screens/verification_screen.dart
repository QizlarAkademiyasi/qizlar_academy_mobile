import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_args.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_screen_mixin.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.args});

  final VerificationArgs args;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with VerificationScreenMixin<VerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  late String _keyHash;

  @override
  void initState() {
    super.initState();
    _keyHash = widget.args.keyHash;
    startResendCountdown();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _onCodeCompleted(String value) async {
    await verifyCode(
      phone: widget.args.phone,
      keyHash: _keyHash,
      code: value,
      onOtpRejectedByServer: () {
        if (mounted) _pinController.clear();
      },
    );
  }

  Future<void> _onResendTap() async {
    final nextHash = await resendCode(phone: widget.args.phone);
    if (nextHash == null || nextHash.isEmpty) return;
    _keyHash = nextHash;
    _pinController.clear();
    resetOtpPinErrorState();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.text;
    final secondary = context.appColors.secondaryGrey;

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              const SizedBox(height: 24),
              Text(
                context.l10n.verificationTitle,
                style: context.textTheme.heading3.copyWith(color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.verificationCodeSentTo(
                  formatPhoneForUi(widget.args.phone),
                ),
                style: context.textTheme.bodyXLargeRegular.copyWith(
                  color: secondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              Pinput(
                controller: _pinController,
                length: 6,
                autofocus: true,
                enabled: !isVerifying,
                keyboardType: TextInputType.number,
                onChanged: onOtpPinEdited,
                onCompleted: _onCodeCompleted,
                forceErrorState: otpPinError,
                showErrorWhenFocused: true,
                defaultPinTheme: _pinTheme(context),
                focusedPinTheme: _pinTheme(
                  context,
                  borderColor: context.appColors.primary,
                ),
                submittedPinTheme: _pinTheme(context),
                errorPinTheme: _pinTheme(
                  context,
                  borderColor: context.appColors.error,
                  textColor: context.appColors.error,
                ),
              ),
              const Spacer(),
              Center(
                child: canResendCode
                    ? PrimaryButton.text(
                        label: isResending
                            ? context.l10n.resending
                            : context.l10n.resendCode,
                        onPressed: isResending ? null : _onResendTap,
                        textStyle: context.textTheme.bodyLargeSemibold.copyWith(
                          color: context.appColors.text,
                        ),
                      )
                    : Text(
                        context.l10n.resendCodeCountdown(
                          formatResendCountdown(),
                        ),
                        style: context.textTheme.bodyLargeRegular.copyWith(
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PinTheme _pinTheme(
    BuildContext context, {
    Color? borderColor,
    Color? textColor,
  }) {
    return PinTheme(
      width: 52,
      height: 56,
      textStyle: context.textTheme.bodyXLargeSemibold.copyWith(
        color: textColor ?? context.appColors.text,
      ),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: borderColor ?? context.appColors.stroke),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pop(),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Icon(LucideIcons.chevronLeft, color: context.appColors.text),
        ),
      ),
    );
  }
}
