import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

Future<void> showAuthRequiredBottomSheet(
  BuildContext context, {
  String? title,
  String? description,
}) {
  return showAppBottomSheet<void>(
    context,
    child: AppBottomSheetContainer(
      // title: 'Tizimga kirish',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Lottie.asset(UiKitAssets.lottie.rabbit.hmmmRabbit),
          ),
          const SizedBox(height: 24),
          Text(
            title ?? 'Tizimga kiring',
            style: context.textTheme.heading5.copyWith(
              color: context.appColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description ??
                'Darsni ko‘rishni davom ettirish uchun tizimga kirishingiz lozim. '
                    'Tizimga kirmaganingizcha testlarni yecha olmaysiz.',
            style: context.textTheme.bodyMediumRegular.copyWith(
              color: context.appColors.secondaryGrey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          // Spacer(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton.elevated(
              label: 'Kirish',
              onPressed: () {
                context.pop();
                context.push(Routes.signIn);
              },
            ),
          ),
        ],
      ),
    ),
  );
}
