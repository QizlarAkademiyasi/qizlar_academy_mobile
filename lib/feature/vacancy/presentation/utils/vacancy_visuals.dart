import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';

/// [AppColors.other*] dan barqaror “tasodifiy” pastel fon (har bir [id] uchun bir xil).
Color vacancyCardTopTint(String id) {
  const pool = <Color>[
    AppColors.otherRed,
    AppColors.otherPink,
    AppColors.otherPurple,
    AppColors.otherDeepPurple,
    AppColors.otherIndigo,
    AppColors.otherBlue,
    AppColors.otherGreen,
    AppColors.otherBlueGrey,
  ];
  final i = id.hashCode.abs() % pool.length;
  return pool[i].withValues(alpha: 0.1);
}

/// Kategoriya (masalan `business`, `craftsmanship`) bo‘yicha ikonka — 2-rasmdagi yo‘nalishlar.
IconData vacancyCategoryIcon(String rawCategory) {
  final key = rawCategory.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_').replaceAll('-', '_');

  if (key.contains('business') || key.contains('tadbir')) {
    return LucideIcons.chartPie;
  }
  if (key.contains('craft') || key.contains('hunarmand') || key.contains('hand')) {
    return LucideIcons.palette;
  }
  if (key.contains('it') || key.contains('media') || key.contains('texno')) {
    return LucideIcons.codeXml;
  }
  if (key.contains('edu') || key.contains('talim') || key.contains("ta'lim")) {
    return LucideIcons.graduationCap;
  }
  if (key.contains('law') || key.contains('huquq') || key.contains('legal')) {
    return LucideIcons.landmark;
  }
  if (key.contains('psych') || key.contains('psix')) {
    return LucideIcons.brain;
  }
  if (key.contains('health') || key.contains('salomat') || key.contains('medic')) {
    return LucideIcons.activity;
  }
  if (key.contains('family') || key.contains('oila')) {
    return LucideIcons.usersRound;
  }

  return LucideIcons.briefcase;
}
