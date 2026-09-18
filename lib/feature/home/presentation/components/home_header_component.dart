import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeHeaderComponent extends StatelessWidget {
  const HomeHeaderComponent({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          key: const ValueKey('home-large-greeting'),
          style: context.textTheme.heading4.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: context.appColors.text,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
