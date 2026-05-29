import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/register/pages/register_screen_mixin.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with RegisterScreenMixin<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackButton.glass(onTap: onBackTap),
                const SizedBox(height: 24),
                Text(context.l10n.registerTitle, style: context.textTheme.heading3.copyWith(color: context.appColors.text)),
                const SizedBox(height: 8),
                Text(context.l10n.registerSubtitle, style: context.textTheme.bodyMediumMedium.copyWith(color: context.appColors.secondaryGrey)),
                const SizedBox(height: 28),
                AppTextField(
                  controller: _firstNameController,
                  hintText: context.l10n.firstNameHint,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.givenName],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _lastNameController,
                  hintText: context.l10n.lastNameHint,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.familyName],
                ),
                const Spacer(),
                PrimaryButton.elevated(
                  label: context.l10n.registerContinue,
                  isLoading: isSubmitting,
                  onPressed: () {
                    onContinueTap(firstName: _firstNameController.text, lastName: _lastNameController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
