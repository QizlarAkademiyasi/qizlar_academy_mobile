import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';

class PortfolioSegmentedTabs extends StatelessWidget {
  const PortfolioSegmentedTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PortfolioFeedTab selected;
  final ValueChanged<PortfolioFeedTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: context.appColors.stroke,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          _TabButton(
            label: 'Barchasi',
            selected: selected == PortfolioFeedTab.all,
            onTap: () => onChanged(PortfolioFeedTab.all),
          ),
          const SizedBox(width: 8),
          _TabButton(
            label: 'Mening loyihalarim',
            selected: selected == PortfolioFeedTab.mine,
            onTap: () => onChanged(PortfolioFeedTab.mine),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? context.appColors.onContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMediumSemibold.copyWith(
                color: selected ? AppColors.primary : context.appColors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
