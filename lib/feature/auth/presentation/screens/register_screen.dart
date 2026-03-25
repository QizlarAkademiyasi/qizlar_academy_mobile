import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/register_screen_mixin.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with RegisterScreenMixin<RegisterScreen> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBackButton.glass(onTap: onBackTap),
              const SizedBox(height: 24),
              Text(
                'Shaxsiy ma\'lumotlar',
                style: context.textTheme.heading3.copyWith(
                  color: context.appColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Shaxsiy ma\'lumotlaringizni kiriting',
                style: context.textTheme.bodyLargeRegular.copyWith(
                  color: context.appColors.secondaryGrey,
                ),
              ),
              const SizedBox(height: 28),
              _buildTextField(
                controller: _firstNameController,
                label: 'Ism',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lastNameController,
                label: 'Familya',
              ),
              const Spacer(),
              PrimaryButton.elevated(
                label: 'Davom etish',
                isLoading: isSubmitting,
                onPressed: () {
                  onContinueTap(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
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
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              style: context.textTheme.bodyLargeMedium.copyWith(
                color: context.appColors.text,
              ),
              decoration: InputDecoration(
                isDense: true,
                labelText: label,
                labelStyle: context.textTheme.bodyLargeMedium.copyWith(
                  color: context.appColors.secondaryGrey,
                ),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

