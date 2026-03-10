import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: Text(
          'Kurslar',
          style: context.textTheme.heading4.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
