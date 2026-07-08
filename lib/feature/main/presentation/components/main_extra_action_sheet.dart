import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

class MainExtraActionSheet extends StatelessWidget {
  const MainExtraActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in kMainExtraMenuItems)
            _ExtraActionItem(
              icon: item.icon,
              iconBackground: item.iconBackground,
              label: item.label,
              subtitle: _subtitleForItem(item),
              onTap: () {
                if (item.route != null) {
                  _openRoute(context, item.route!);
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  String _subtitleForItem(MainExtraMenuItem item) {
    return switch (item.label) {
      "Do'kon" => "Ballarni sovg'aga almashtiring",
      'Vakansiyalar' => 'Kelajak kasbingizni toping',
      'Portfolio' => "Loyihalarni ko'ring va ulashing",
      'Elchilar' => 'Faol taklif qiluvchilar',
      _ => "Bilimingiz va tajribangiz bilan bo'lishing",
    };
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
      decoration: BoxDecoration(
        color: context.appColors.stroke,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: context.appColors.text, size: 18),
          const SizedBox(width: 8),
          Text(
            'Izlash',
            style: context.textTheme.bodyLargeMedium.copyWith(
              color: context.appColors.text.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtraActionItem extends StatelessWidget {
  const _ExtraActionItem({
    required this.icon,
    required this.iconBackground,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

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
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: AppColors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.textTheme.bodyLargeSemibold.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: context.textTheme.bodyMediumRegular.copyWith(
                        color: context.appColors.grey,
                      ),
                    ),
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
