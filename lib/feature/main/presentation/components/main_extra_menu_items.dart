import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';

const int kMainProfileTabIndex = 3;

/// Kengaygan More menyusidagi umumiy vizual ma'lumotlar.
sealed class MainExtraMenuItem {
  const MainExtraMenuItem({
    required this.icon,
    required this.iconBackground,
    required this.label,
  });

  final IconData icon;
  final Color iconBackground;
  final String label;

  /// Eski bottom sheet bilan moslik uchun. Faqat route itemlarda qiymat bor.
  String? get route => null;
}

/// Main shell ichidagi PageView tabini tanlaydigan item.
final class MainExtraTabMenuItem extends MainExtraMenuItem {
  const MainExtraTabMenuItem({
    required super.icon,
    required super.iconBackground,
    required super.label,
    required this.tabIndex,
  });

  final int tabIndex;
}

/// Main shell ustidan alohida screen sifatida ochiladigan route item.
final class MainExtraRouteMenuItem extends MainExtraMenuItem {
  const MainExtraRouteMenuItem({
    required super.icon,
    required super.iconBackground,
    required super.label,
    required this.screenRoute,
  });

  final String screenRoute;

  @override
  String get route => screenRoute;
}

enum MainExtraMenuAction { joinTeam }

/// Route yoki tabga bog'lanmagan maxsus action.
final class MainExtraActionMenuItem extends MainExtraMenuItem {
  const MainExtraActionMenuItem({
    required super.icon,
    required super.iconBackground,
    required super.label,
    required this.action,
  });

  final MainExtraMenuAction action;
}

/// Main shell ichida tanlanadigan tablar.
const List<MainExtraTabMenuItem> kMainExtraTabMenuItems = [
  MainExtraTabMenuItem(
    icon: LucideIcons.userRound,
    iconBackground: Color(0xFF7B61FF),
    label: 'Profil',
    tabIndex: kMainProfileTabIndex,
  ),
];

/// BottomNav shellidan tashqarida alohida screen sifatida ochiladigan bo'limlar.
const List<MainExtraRouteMenuItem> kMainExtraRouteMenuItems = [
  MainExtraRouteMenuItem(
    icon: LucideIcons.graduationCap,
    iconBackground: Color(0xFF3357C9),
    label: 'Kurslar',
    screenRoute: Routes.courses,
  ),
  MainExtraRouteMenuItem(
    icon: LucideIcons.clipboardCheck,
    iconBackground: Color(0xFF1EA672),
    label: 'Vazifalar',
    screenRoute: Routes.tasks,
  ),
  MainExtraRouteMenuItem(
    icon: LucideIcons.briefcaseBusiness,
    iconBackground: Color(0xFFFF6B1A),
    label: 'Vakansiyalar',
    screenRoute: Routes.vacancies,
  ),
  MainExtraRouteMenuItem(
    icon: LucideIcons.medal,
    iconBackground: Color(0xFF6A4A3B),
    label: 'Elchilar',
    screenRoute: Routes.referral,
  ),
];

/// Alohida navigatsiyasiz maxsus amallar.
const List<MainExtraActionMenuItem> kMainExtraActionMenuItems = [
  MainExtraActionMenuItem(
    icon: LucideIcons.badgePlus,
    iconBackground: Color(0xFFE8357D),
    label: "Jamoaga qo'shilish",
    action: MainExtraMenuAction.joinTeam,
  ),
];

/// UI uchun birlashtirilgan ro'yxat; yuqoridagi ro'yxatlar navigatsiya turiga
/// qarab alohida saqlanadi.
const List<MainExtraMenuItem> kMainExtraMenuItems = [
  ...kMainExtraTabMenuItems,
  ...kMainExtraRouteMenuItems,
  ...kMainExtraActionMenuItems,
];
