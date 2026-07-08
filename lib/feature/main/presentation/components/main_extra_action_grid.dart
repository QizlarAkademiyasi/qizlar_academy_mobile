import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

/// Plus-menyu: 3 ustunli grid — icon + label (ClickUp uslubidagi kengaygan pastki nav).
class MainExtraActionGrid extends StatelessWidget {
  const MainExtraActionGrid({super.key, required this.onItemTap, this.items = kMainExtraMenuItems});

  final ValueChanged<MainExtraMenuItem> onItemTap;
  final List<MainExtraMenuItem> items;

  static const int crossAxisCount = 3;
  static const double spacing = 10;
  static const double tileSize = 56;
  static const double labelGap = 6;
  static const double labelHeight = 30;
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(12, 14, 12, 10);

  static int rowCountFor(int itemCount, {int columns = crossAxisCount}) {
    if (itemCount <= 0) return 0;
    return (itemCount / columns).ceil();
  }

  static double rowHeightFor() => tileSize + labelGap + labelHeight;

  /// Grid balandligi — elementlar soni va qatorlar bo‘yicha (animatsiya konteyneri uchun).
  static double preferredHeightFor(int itemCount, {int columns = crossAxisCount}) {
    if (itemCount <= 0) return 0;
    final rows = rowCountFor(itemCount, columns: columns);
    final gridHeight = rows * rowHeightFor() + (rows - 1) * spacing;
    return contentPadding.vertical + gridHeight;
  }

  @override
  Widget build(BuildContext context) {
    final tileBg = secondLiquidBottomNavTileSurface(context);
    final rows = rowCountFor(items.length);

    return SizedBox(
      height: preferredHeightFor(items.length),
      width: double.infinity,
      child: Padding(
        padding: contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) const SizedBox(height: spacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var col = 0; col < crossAxisCount; col++) ...[
                    if (col > 0) const SizedBox(width: spacing),
                    Expanded(
                      child: _cellForIndex(context, row * crossAxisCount + col, tileBg),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cellForIndex(BuildContext context, int index, Color tileBg) {
    if (index >= items.length) {
      return SizedBox(height: rowHeightFor());
    }
    final item = items[index];
    return _MainExtraActionGridTile(item: item, tileBackground: tileBg, onTap: () => onItemTap(item));
  }
}

class _MainExtraActionGridTile extends StatelessWidget {
  const _MainExtraActionGridTile({required this.item, required this.tileBackground, required this.onTap});

  final MainExtraMenuItem item;
  final Color tileBackground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: SizedBox(
          height: MainExtraActionGrid.rowHeightFor(),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MainExtraActionGrid.tileSize,
                height: MainExtraActionGrid.tileSize,
                decoration: BoxDecoration(
                  color: tileBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.iconBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: AppColors.white, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: MainExtraActionGrid.labelGap),
              SizedBox(
                height: MainExtraActionGrid.labelHeight,
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.appColors.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
