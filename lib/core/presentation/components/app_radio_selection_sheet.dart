import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_bottom_sheet.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_text_field.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/primary_button.dart';

/// Umumiy radio-tanlash sahifasi: [items] ro'yxatidan bittasini tanlash.
/// [showAppRadioSelectionSheet] orqali chaqiriladi.
class AppRadioSelectionItem<T> {
  const AppRadioSelectionItem({required this.value, required this.label});
  final T value;
  final String label;
}

Future<T?> showAppRadioSelectionSheet<T>(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<AppRadioSelectionItem<T>> items,
  required String confirmLabel,
  T? selectedValue,
  bool searchable = false,
  String? searchHint,
}) {
  return showAppBottomSheet<T>(
    context,
    child: _RadioSelectionSheetBody<T>(
      title: title,
      subtitle: subtitle,
      items: items,
      confirmLabel: confirmLabel,
      selectedValue: selectedValue,
      searchable: searchable,
      searchHint: searchHint,
    ),
  );
}

class _RadioSelectionSheetBody<T> extends StatefulWidget {
  const _RadioSelectionSheetBody({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.confirmLabel,
    this.selectedValue,
    this.searchable = false,
    this.searchHint,
  });

  final String title;
  final String subtitle;
  final List<AppRadioSelectionItem<T>> items;
  final String confirmLabel;
  final T? selectedValue;
  final bool searchable;
  final String? searchHint;

  @override
  State<_RadioSelectionSheetBody<T>> createState() => _RadioSelectionSheetBodyState<T>();
}

class _RadioSelectionSheetBodyState<T> extends State<_RadioSelectionSheetBody<T>> {
  T? _selected;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedValue;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppRadioSelectionItem<T>> get _filteredItems {
    if (_query.isEmpty) return widget.items;
    final lower = _query.toLowerCase();
    return widget.items.where((item) => item.label.toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final filtered = _filteredItems;

    return AppBottomSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: context.textTheme.bodyXLargeSemibold.copyWith(color: colors.text)),
          const SizedBox(height: 4),
          Text(widget.subtitle, style: context.textTheme.bodyMediumRegular.copyWith(color: colors.secondaryGrey)),
          const SizedBox(height: 16),
          if (widget.searchable) ...[
            AppTextField(
              controller: _searchController,
              hintText: widget.searchHint ?? 'Qidirish',
              suffix: Icon(LucideIcons.search, size: 20, color: colors.secondaryGrey),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final isSelected = item.value == _selected;
                return _RadioTile<T>(
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selected = item.value),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton.elevated(
            label: widget.confirmLabel,
            onPressed: _selected != null ? () => Navigator.of(context).pop(_selected) : null,
          ),
        ],
      ),
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  const _RadioTile({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.textTheme.bodyLargeMedium.copyWith(color: colors.text),
              ),
            ),
            _RadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? colors.primary : colors.stroke, width: 2),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primary),
              ),
            )
          : null,
    );
  }
}
