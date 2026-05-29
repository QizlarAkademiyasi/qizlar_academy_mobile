import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class MainExtraActionSheet extends StatelessWidget {
  const MainExtraActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      // isBackgorun: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const _SearchFieldPlaceholder(),
          // const SizedBox(height: 14),
          _ExtraActionItem(
            icon: LucideIcons.store,
            iconBackground: const Color(0xFF3357C9),
            label: "Do'kon",
            subtitle: "Ballarni sovg'aga almashtiring",
            onTap: () => _openRoute(context, Routes.store),
          ),
          _ExtraActionItem(
            icon: LucideIcons.briefcaseBusiness,
            iconBackground: const Color(0xFFFF6B1A),
            label: 'Vakansiyalar',
            subtitle: 'Kelajak kasbingizni toping',
            onTap: () => _openRoute(context, Routes.vacancies),
          ),
          _ExtraActionItem(icon: LucideIcons.medal, iconBackground: const Color(0xFF6A4A3B), label: 'Elchilar', subtitle: 'Faol taklif qiluvchilar', onTap: () => _openRoute(context, Routes.referral)),
          // _ExtraActionItem(icon: LucideIcons.bookOpenCheck, iconBackground: const Color(0xFF8A2BE2), label: 'Kurslar', subtitle: 'Barcha kurslar', onTap: () => _openRoute(context, Routes.mainUser)),
          // _ExtraActionItem(
          //   icon: LucideIcons.clipboardCheck,
          //   iconBackground: const Color(0xFF00A3FF),
          //   label: 'Vazifalar',
          //   subtitle: 'Description',
          //   onTap: () => Navigator.of(context).pop(),
          // ),
          _ExtraActionItem(
            icon: LucideIcons.badgePlus,
            iconBackground: const Color(0xFFE8357D),
            label: "Bizning jamoaga qo'shilish",
            subtitle: "Bilimingiz va tajribangiz bilan bo'lishing",
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.push(route);
  }
}

class _SearchFieldPlaceholder extends StatelessWidget {
  const _SearchFieldPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(color: context.appColors.stroke, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: context.appColors.text, size: 18),
          const SizedBox(width: 8),
          Text('Izlash', style: context.textTheme.bodyLargeMedium.copyWith(color: context.appColors.text.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _ExtraActionItem extends StatelessWidget {
  const _ExtraActionItem({required this.icon, required this.iconBackground, required this.label, required this.subtitle, required this.onTap});

  final IconData icon;
  final Color iconBackground;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(11)),
                child: Icon(icon, color: AppColors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text)),
                    const SizedBox(height: 1),
                    Text(subtitle, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
