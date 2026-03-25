import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/notification_screen_mixin.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NotificationBloc>()..add(const NotificationStarted()),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatefulWidget {
  const _NotificationView();

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView>
    with NotificationScreenMixin<_NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: notificationBlocListener,
          builder: (context, state) {
            final isInitialLoading =
                (state.status == NotificationStatus.loading ||
                    state.status == NotificationStatus.initial) &&
                state.sections.isEmpty;

            return Column(
              children: [
                buildTopBar(context, hasUnread: state.hasUnread),
                Expanded(
                  child: switch ((state.status, state.sections.isEmpty)) {
                    (NotificationStatus.failure, true) => TgsFailureContent(
                      message: state.message,
                      onRetry: () => retry(context),
                    ),
                    (_, true) when isInitialLoading => const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: NotificationListSkeleton(),
                    ),
                    (_, true) => const NotificationEmptyContent(),
                    _ => _buildSectionsList(context, state),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionsList(BuildContext context, NotificationState state) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 28 + bottomInset),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) return const SizedBox(height: 28);
                final sectionIndex = index ~/ 2;
                final section = state.sections[sectionIndex];
                return buildSection(context, section: section);
              },
              childCount: state.sections.isEmpty
                  ? 0
                  : state.sections.length * 2 - 1,
            ),
          ),
        ),
      ],
    );
  }
}
