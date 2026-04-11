import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CoursesSearchField extends StatelessWidget {
  const CoursesSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.heroTag,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.focusNode,
  });

  /// Kurslar ro‘yxati ↔ qidiruv ekrani o‘rtasida [Hero] animatsiyasi.
  static const String kHeroTag = 'courses_catalog_search_field';

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Object? heroTag;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      cursorColor: AppColors.primary,
      style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.text),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          hintText: context.l10n.coursesSearchHint,
          hintStyle: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey),
          prefixIcon: Icon(LucideIcons.search, size: 18, color: context.appColors.secondaryGrey),
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
    );

    final wrapped = Material(
      type: MaterialType.transparency,
      child: field,
    );

    final heroChild = heroTag != null ? Hero(tag: heroTag!, child: wrapped) : wrapped;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: heroChild,
    );
  }
}
