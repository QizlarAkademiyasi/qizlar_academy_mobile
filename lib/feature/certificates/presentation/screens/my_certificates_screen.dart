import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/bloc/my_certificates_bloc.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/screens/my_certificates_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

class MyCertificatesScreen extends StatelessWidget {
  const MyCertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyCertificatesBloc>()..add(const MyCertificatesStarted()),
      child: const _MyCertificatesView(),
    );
  }
}

class _MyCertificatesView extends StatefulWidget {
  const _MyCertificatesView();

  @override
  State<_MyCertificatesView> createState() => _MyCertificatesViewState();
}

class _MyCertificatesViewState extends State<_MyCertificatesView> with MyCertificatesScreenMixin<_MyCertificatesView> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: buildMyCertificatesTopBar(context)),
            Expanded(
              child: BlocBuilder<MyCertificatesBloc, MyCertificatesState>(
                buildWhen: (p, c) => p.status != c.status || p.items != c.items,
                builder: (context, state) {
                  final loadingEmpty = (state.status == MyCertificatesStatus.loading || state.status == MyCertificatesStatus.initial) && state.items.isEmpty;

                  if (state.status == MyCertificatesStatus.failure && state.items.isEmpty) {
                    return TgsFailureContent(
                      message: context.l10n.certificatesLoadError,
                      onRetry: () => context.read<MyCertificatesBloc>().add(const MyCertificatesRetryRequested()),
                    );
                  }

                  if (loadingEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == MyCertificatesStatus.success && state.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TgsEmptyContent(
                          message: context.l10n.certificatesEmptyTitle,
                          subtitle: context.l10n.certificatesEmptySubtitle,
                        ),
                      ),
                    );
                  }

                  return AppStaggeredScrollLimiter(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(20, 4, 20, 24 + bottomInset),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return AppStaggeredListItem(
                          position: index,
                          child: buildCertificateCard(context, state.items[index], index),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
