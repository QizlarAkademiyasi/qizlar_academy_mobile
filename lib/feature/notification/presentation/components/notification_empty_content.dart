import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class NotificationEmptyContent extends StatelessWidget {
  const NotificationEmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                shape: BoxShape.circle,
                border: Border.all(color: context.appColors.stroke),
              ),
              child: Icon(
                LucideIcons.bell,
                color: context.appColors.secondaryGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hozircha bildirishnomalar yo\'q',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLargeSemibold.copyWith(
                color: context.appColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Yangi xabarlar paydo bo\'lishi bilan shu yerda ko\'rinadi.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMediumRegular.copyWith(
                color: context.appColors.secondaryGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
