import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CoursesSearchField extends StatelessWidget {
  const CoursesSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: AppColors.primary,
        style: context.textTheme.bodyMediumRegular.copyWith(
          color: context.appColors.text,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Kurslarni izlash...',
          hintStyle: context.textTheme.bodyMediumRegular.copyWith(
            color: context.appColors.secondaryGrey,
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 18,
            color: context.appColors.secondaryGrey,
          ),
          filled: true,
          fillColor: context.appColors.onContainer,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: context.appColors.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: context.appColors.stroke),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
