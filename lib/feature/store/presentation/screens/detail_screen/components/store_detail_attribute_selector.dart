import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_group_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_attribute_value_model.dart';

class StoreDetailAttributeSelector extends StatelessWidget {
  const StoreDetailAttributeSelector({super.key, required this.groups, required this.selectedValues, required this.onValueSelected});

  final List<StoreAttributeGroupModel> groups;
  final Map<String, String> selectedValues;
  final void Function(String key, String valueId) onValueSelected;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.map((group) {
        final isColor = group.key.toLowerCase() == 'color';
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_localizeKey(group.key), style: context.textTheme.bodyMediumBold.copyWith(color: AppColors.primary)),
              const SizedBox(height: 8),
              isColor ? _buildColorRow(context, group) : _buildChipRow(context, group),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorRow(BuildContext context, StoreAttributeGroupModel group) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: group.values.map((val) {
        final isSelected = selectedValues[group.key] == val.id;
        return _ColorDot(value: val, isSelected: isSelected, onTap: () => onValueSelected(group.key, val.id));
      }).toList(),
    );
  }

  Widget _buildChipRow(BuildContext context, StoreAttributeGroupModel group) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: group.values.map((val) {
        final isSelected = selectedValues[group.key] == val.id;
        return _AttributeChip(value: val, isSelected: isSelected, onTap: () => onValueSelected(group.key, val.id));
      }).toList(),
    );
  }

  String _localizeKey(String key) {
    return switch (key.toLowerCase()) {
      'color' => 'Barcha turlar',
      'size' => "O'lcham",
      'duration' => "Barcha turlar",
      _ => key,
    };
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.value, required this.isSelected, required this.onTap});

  final StoreAttributeValueModel value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = value.hexCode != null ? _parseColor(value.hexCode!) : context.appColors.grey;

    return AppLiquidStretch.compact(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: isSelected ? Border.all(color: context.appColors.primary, width: 1.5) : Border.all(color: context.appColors.stroke),
              ),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            ),
            const SizedBox(height: 4),
            Text(value.value, style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.text, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final code = hex.replaceAll('#', '');
    if (code.length == 6) return Color(int.parse('FF$code', radix: 16));
    if (code.length == 8) return Color(int.parse(code, radix: 16));
    return const Color(0xFF888888);
  }
}

class _AttributeChip extends StatelessWidget {
  const _AttributeChip({required this.value, required this.isSelected, required this.onTap});

  final StoreAttributeValueModel value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppLiquidStretch.compact(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isSelected ? context.appColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            border: Border.all(color: isSelected ? context.appColors.primary : context.appColors.stroke),
          ),
          child: Text(value.value, style: context.textTheme.bodyMediumSemibold.copyWith(color: isSelected ? AppColors.white : context.appColors.text)),
        ),
      ),
    );
  }
}
