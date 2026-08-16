import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// To‘liq ekranlarni pastdan yuqoriga modal uslubida ochadi.
CustomTransitionPage<void> buildBottomUpRoutePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final position = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
      return SlideTransition(position: position, child: child);
    },
  );
}
