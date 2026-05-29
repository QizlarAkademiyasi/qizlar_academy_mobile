import 'package:flutter/widgets.dart';
import 'package:qizlar_academy_mobile/config/constants/app_tablet_layout.dart';

/// Planshetda [child] ni iPhone 17 Pro Max mantiqiy kengligi ([AppTabletLayout.contentMaxWidthPoints]) bilan cheklaydi.
///
/// Telefonda o‘zgarishsiz qaytaradi. [alignment] — keng parent ichida gorizontal joylashuv.
class AppTabletMaxWidth extends StatelessWidget {
  const AppTabletMaxWidth({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    if (!AppTabletLayout.isTabletSized(MediaQuery.sizeOf(context))) {
      return child;
    }
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppTabletLayout.contentMaxWidthPoints,
        ),
        child: child,
      ),
    );
  }
}
