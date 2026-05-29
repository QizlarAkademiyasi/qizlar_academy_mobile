import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreCategoryChip {
  const StoreCategoryChip({required this.id, required this.label, this.count});

  final String? id;
  final String label;
  final int? count;
}

class StoreCategoryChips extends StatefulWidget {
  const StoreCategoryChips({super.key, required this.categories, required this.selectedId, required this.onSelected});

  final List<StoreCategoryChip> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  State<StoreCategoryChips> createState() => _StoreCategoryChipsState();
}

class _StoreCategoryChipsState extends State<StoreCategoryChips> {
  final ScrollController _controller = ScrollController();
  final Map<String?, GlobalKey> _keys = <String?, GlobalKey>{};

  GlobalKey _keyFor(String? id) => _keys.putIfAbsent(id, GlobalKey.new);

  @override
  void didUpdateWidget(covariant StoreCategoryChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      _ensureSelectedVisible();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSelectedVisible());
  }

  void _ensureSelectedVisible() {
    final key = _keys[widget.selectedId];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = widget.categories[index];
          final isSelected = chip.id == widget.selectedId;
          return KeyedSubtree(
            key: _keyFor(chip.id),
            child: _ChipItem(chip: chip, isSelected: isSelected, onTap: () => widget.onSelected(chip.id)),
          );
        },
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  const _ChipItem({required this.chip, required this.isSelected, required this.onTap});

  final StoreCategoryChip chip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? context.appColors.primary : context.appColors.onContainer;
    final fg = isSelected ? AppColors.white : context.appColors.text;
    final borderColor = isSelected ? context.appColors.primary : context.appColors.stroke;

    return AppLiquidStretch.compact(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(chip.label, style: context.textTheme.bodyMediumSemibold.copyWith(color: fg)),
              if (chip.count != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white.withValues(alpha: 0.2) : context.appColors.stroke,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${chip.count}', style: context.textTheme.bodySmallSemibold.copyWith(color: fg, fontSize: 11)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
