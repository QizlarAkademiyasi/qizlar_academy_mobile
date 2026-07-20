import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/bloc/my_activity_bloc.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/screens/activity_screen_mixin.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyActivityBloc>()..add(const MyActivityStarted()),
      child: const _ActivityView(),
    );
  }
}

class _ActivityView extends StatefulWidget {
  const _ActivityView();

  @override
  State<_ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<_ActivityView>
    with SingleTickerProviderStateMixin, ActivityScreenMixin<_ActivityView> {
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
    return AppPageScaffold(
      title: context.l10n.activityScreenTitle,
      centerTitle: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
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
    );
  }
}
