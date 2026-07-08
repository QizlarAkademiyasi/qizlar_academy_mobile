import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';

class PortfolioEmptyContent extends StatelessWidget {
  const PortfolioEmptyContent({
    super.key,
    required this.tab,
    required this.isGuest,
    this.onCreateTap,
  });

  final PortfolioFeedTab tab;
  final bool isGuest;
  final VoidCallback? onCreateTap;

  bool get _isMineTab => tab == PortfolioFeedTab.mine;

  @override
  Widget build(BuildContext context) {
    if (_isMineTab && !isGuest) {
      return _MineEmptyContent(onCreateTap: onCreateTap);
    }
    return _FeedEmptyContent(isMineTab: _isMineTab);
  }
}

class _FeedEmptyContent extends StatelessWidget {
  const _FeedEmptyContent({required this.isMineTab});

  final bool isMineTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TgsEmptyContent(
          message: isMineTab ? 'Hali loyiha yo\'q' : 'Lenta hali bo\'sh',
          subtitle: isMineTab
              ? 'Tizimga kirib, birinchi loyihangizni joylang.'
              : 'Hamjamiyat a\'zolari portfolio joylaganda shu yerda ko\'rasiz.',
          tgsAsset: UiKitAssets.lottie.rabbit.missYouRabbit,
          animationSize: 100,
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: const [
            _TopicChip(icon: LucideIcons.image, label: 'Rasm'),
            _TopicChip(icon: LucideIcons.video, label: 'Video'),
            _TopicChip(icon: LucideIcons.sparkles, label: 'G\'oya'),
          ],
        ),
      ],
    );
  }
}

class _MineEmptyContent extends StatelessWidget {
  const _MineEmptyContent({this.onCreateTap});

  final VoidCallback? onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TgsEmptyContent(
          message: 'Birinchi loyihangizni yarating!',
          subtitle:
              'Kurs natijangiz, loyiha yoki g\'oyangizni rasm yoki video bilan ulashing.',
          tgsAsset: UiKitAssets.lottie.rabbit.rainbowRabbit,
          animationSize: 108,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Column(
            children: [
              _HintRow(
                icon: LucideIcons.images,
                title: 'Media tanlang',
                subtitle: 'Rasm yoki qisqa video qo\'shing',
              ),
              Divider(height: 24, thickness: 1, color: context.appColors.stroke),
              _HintRow(
                icon: LucideIcons.pencilLine,
                title: 'Qisqa tavsif yozing',
                subtitle: 'Nima qilganingiz haqida 2–3 jumla yetarli',
              ),
              Divider(height: 24, thickness: 1, color: context.appColors.stroke),
              _HintRow(
                icon: LucideIcons.rocket,
                title: 'Joylab, ulashing',
                subtitle: 'Hamjamiyat natijangizni ko\'rib, qo\'llab-quvvatlaydi',
              ),
            ],
          ),
        ),
        if (onCreateTap != null) ...[
          const SizedBox(height: 20),
          PrimaryButton.elevated(
            label: 'Portfolio joylash',
            leading: const Icon(LucideIcons.circlePlus, size: 20),
            onPressed: onCreateTap,
            shape: AppPrimaryButtonShape.roundedRectangle,
          ),
        ],
      ],
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: context.appColors.secondaryGrey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.bodySmallRegular.copyWith(
              color: context.appColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
