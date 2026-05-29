import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

/// Reyting: bo‘sh yulduzlar outline (kulrang), to‘ldirilganlar — [filledColor].
///
/// Ranglar ixtiyoriy; [emptyColor] berilmasa `context.appColors.stroke` ishlatiladi.
class AppRatingStarsRow extends StatelessWidget {
  const AppRatingStarsRow({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.filledColor = AppColors.primary,
    this.emptyColor,
    this.iconSize = 14,
    this.spacing = 2,
    this.showHalfStars = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  /// 0 .. [maxStars]
  final double rating;
  final int maxStars;
  final Color filledColor;
  final Color? emptyColor;
  final double iconSize;
  final double spacing;
  final bool showHalfStars;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final empty = emptyColor ?? context.appColors.stroke;
    final cap = maxStars.toDouble();
    final clamped = rating.clamp(0, cap);
    final full = clamped.floor().clamp(0, maxStars);
    final hasHalf = showHalfStars && (clamped - full) >= 0.5 && full < maxStars;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(maxStars, (index) {
        final isFull = index < full;
        final isHalf = index == full && hasHalf;

        late final IconData data;
        late final Color color;
        if (isFull) {
          data = Icons.star_rounded;
          color = filledColor;
        } else if (isHalf) {
          data = Icons.star_half_rounded;
          color = filledColor;
        } else {
          data = Icons.star_border_rounded;
          color = empty;
        }

        return Padding(
          padding: EdgeInsets.only(right: index == maxStars - 1 ? 0 : spacing),
          child: Icon(data, size: iconSize, color: color),
        );
      }),
    );
  }
}
