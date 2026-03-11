import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_bar.dart';

/// Main shell ekrani uchun tab tanlashi va pastki bar qismini qaytaruvchi mixin.
mixin MainScreenMixin<T extends StatefulWidget> on State<T> {
  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 0;

  void onTabTap(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  Widget buildBottomBar(BuildContext context) {
    return MainBottomBar(currentIndex: _selectedIndex, onTap: onTabTap);
  }
}
