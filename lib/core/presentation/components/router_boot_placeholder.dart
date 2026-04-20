import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// [MaterialApp.router] `child` hali `null` bo‘lgan qisqa paytda bo‘sh shrink o‘rniga
/// fon + indikator (oq/qora "bo‘sh" ekranni kamaytirish).
class RouterBootPlaceholder extends StatelessWidget {
  const RouterBootPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return ColoredBox(
      color: bg,
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
