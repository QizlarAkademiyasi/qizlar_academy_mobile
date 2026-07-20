import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';

/// Plus-menyu va kengaygan pastki nav grid uchun umumiy element.
class MainExtraMenuItem {
  const MainExtraMenuItem({
    required this.icon,
    required this.iconBackground,
    required this.label,
    this.route,
  });

  final IconData icon;
  final Color iconBackground;
  final String label;

  /// `null` — maxsus harakat (masalan, hozircha faqat yopish).
  final String? route;
}

const List<MainExtraMenuItem> kMainExtraMenuItems = [
  MainExtraMenuItem(
    icon: LucideIcons.graduationCap,
    iconBackground: Color(0xFF3357C9),
    label: 'Kurslar',
    route: Routes.courses,
  ),
  MainExtraMenuItem(
    icon: LucideIcons.clipboardCheck,
    iconBackground: Color(0xFF1EA672),
    label: 'Vazifalar',
    route: Routes.tasks,
  ),
  MainExtraMenuItem(
    icon: LucideIcons.briefcaseBusiness,
    iconBackground: Color(0xFFFF6B1A),
    label: 'Vakansiyalar',
    route: Routes.vacancies,
  ),
  MainExtraMenuItem(
    icon: LucideIcons.medal,
    iconBackground: Color(0xFF6A4A3B),
    label: 'Elchilar',
    route: Routes.referral,
  ),
  MainExtraMenuItem(
    icon: LucideIcons.badgePlus,
    iconBackground: Color(0xFFE8357D),
    label: "Jamoaga qo'shilish",
  ),
];
