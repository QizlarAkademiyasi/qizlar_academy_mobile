import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// BottomNav tab host: swipe yo‘q, index darhol almashadi.
///
/// Tablar birinchi tanlanganda lazy quriladi va keyin state'i saqlanadi.
/// Tab almashganda outgoing va incoming sahifalar CrossFade (160ms) — butun
/// stack flash emas.
class MainTabStack extends StatefulWidget {
  const MainTabStack({
    super.key,
    required this.selectedIndex,
    required this.fadeNonce,
    required this.pages,
  });

  static const Duration fadeDuration = Duration(milliseconds: 160);

  final int selectedIndex;
  final int fadeNonce;
  final List<Widget> pages;

  @override
  State<MainTabStack> createState() => _MainTabStackState();
}

class _MainTabStackState extends State<MainTabStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: MainTabStack.fadeDuration,
    value: 1,
  );
  late final Animation<double> _incomingOpacity = CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeOut,
  );

  late final Set<int> _builtIndices = <int>{widget.selectedIndex};
  int? _outgoingIndex;

  @override
  void initState() {
    super.initState();
    _fadeController.addStatusListener(_onFadeStatusChanged);
  }

  void _onFadeStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed || _outgoingIndex == null) {
      return;
    }
    if (!mounted) return;
    setState(() => _outgoingIndex = null);
  }

  @override
  void didUpdateWidget(covariant MainTabStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _builtIndices
      ..removeWhere((index) => index >= widget.pages.length)
      ..add(widget.selectedIndex);
    final indexChanged = widget.selectedIndex != oldWidget.selectedIndex;
    final barDroveChange = widget.fadeNonce != oldWidget.fadeNonce;
    if (indexChanged && barDroveChange) {
      _outgoingIndex = oldWidget.selectedIndex;
      _fadeController
        ..stop()
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _fadeController
      ..removeStatusListener(_onFadeStatusChanged)
      ..dispose();
    super.dispose();
  }

  bool _shouldBuild(int index) {
    return _builtIndices.contains(index) || _outgoingIndex == index;
  }

  bool _isOnstage(int index) {
    final crossfading = _outgoingIndex != null && _fadeController.value < 1.0;
    if (crossfading) {
      return index == widget.selectedIndex || index == _outgoingIndex;
    }
    return index == widget.selectedIndex;
  }

  double _opacityFor(int index) {
    if (_outgoingIndex == null) {
      return index == widget.selectedIndex ? 1 : 0;
    }
    if (index == widget.selectedIndex) {
      return _incomingOpacity.value;
    }
    if (index == _outgoingIndex) {
      return 1 - _incomingOpacity.value;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            for (var i = 0; i < widget.pages.length; i++)
              Offstage(
                offstage: !_isOnstage(i),
                child: TickerMode(
                  enabled: i == widget.selectedIndex,
                  child: Opacity(
                    opacity: _opacityFor(i),
                    child: _shouldBuild(i)
                        ? widget.pages[i]
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
