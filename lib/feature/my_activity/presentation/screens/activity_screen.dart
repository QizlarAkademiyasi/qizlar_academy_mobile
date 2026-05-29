import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/bloc/my_activity_bloc.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/screens/activity_screen_mixin.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin, ActivityScreenMixin<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    initActivityTabs();
  }

  @override
  void dispose() {
    disposeActivityTabs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyActivityBloc>()..add(const MyActivityStarted()),
      // [BlocProvider] ostidagi kontekst kerak — aks holda [build] dagi `context`
      // provider dan yuqorida bo‘ladi va segmented tab [read<MyActivityBloc>] xato beradi.
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildActivityTopBar(context),
                  const SizedBox(height: 14),
                  buildActivityTabs(context),
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<MyActivityBloc, MyActivityState>(
                      builder: (context, state) =>
                          buildActivityMainBody(context, state),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
