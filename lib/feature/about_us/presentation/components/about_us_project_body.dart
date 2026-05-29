import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Birinchi qism pushti, qolgan matn ikkilamchi rangda.
class AboutUsProjectBody extends StatelessWidget {
  const AboutUsProjectBody({super.key, required this.lead, required this.body});

  final String lead;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: context.textTheme.bodyLargeRegular.copyWith(color: context.appColors.grey, height: 1.45),
        children: [
          TextSpan(
            text: lead,
            style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.primary),
          ),
          TextSpan(
            text: body,
            style: context.textTheme.bodyLargeRegular.copyWith(color: context.appColors.grey, height: 1.45),
          ),
        ],
      ),
    );
  }
}
