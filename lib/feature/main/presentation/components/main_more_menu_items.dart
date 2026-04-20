import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Pastki «More» paneli va 5-tab sahifasi uchun umumiy ro‘yxat.
class MainMoreMenuItem {
  const MainMoreMenuItem({required this.icon, required this.title, required this.tint});

  final IconData icon;
  final String title;
  final Color tint;
}

/// Tartib [GlassBottomNavigationVersionThree] grid va [MainMoreTabPage] bilan mos kelishi kerak.
const List<MainMoreMenuItem> kMainMoreMenuItems = [
  MainMoreMenuItem(icon: LucideIcons.fileText, title: 'Docs', tint: Color(0xFF2196F3)),
  MainMoreMenuItem(icon: LucideIcons.play, title: 'Clips', tint: Color(0xFFFF5D68)),
  MainMoreMenuItem(icon: LucideIcons.chartPie, title: 'Dashboards', tint: Color(0xFF9C45EA)),
  MainMoreMenuItem(icon: LucideIcons.clipboardCheck, title: 'Forms', tint: Color(0xFF6F5CFF)),
  MainMoreMenuItem(icon: LucideIcons.sparkles, title: 'Brain', tint: Color(0xFF80A8FF)),
  MainMoreMenuItem(icon: LucideIcons.landmark, title: 'Spaces', tint: Color(0xFFB264FF)),
  MainMoreMenuItem(icon: LucideIcons.notebookText, title: 'Notepad', tint: Color(0xFFFFC84D)),
  MainMoreMenuItem(icon: LucideIcons.calendarDays, title: 'Planner', tint: Color(0xFFFF6AAE)),
];
