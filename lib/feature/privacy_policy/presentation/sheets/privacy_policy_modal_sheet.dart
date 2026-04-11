import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/bloc/privacy_policy_bloc.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/components/privacy_policy_markdown_view.dart';

/// [PrivacyPolicyScreen] bilan bir xil markdown ([PrivacyPolicyBloc]), lekin
/// [ModalSheetRoute] + [smooth_sheets] orqali pastdan modal sheet.
void showPrivacyPolicyModalSheet(BuildContext context) {
  Navigator.of(context, rootNavigator: true).push(
    ModalSheetRoute<void>(
      swipeDismissible: true,
      barrierDismissible: true,
      builder: (modalContext) => BlocProvider(
        create: (_) => getIt<PrivacyPolicyBloc>()..add(const PrivacyPolicyStarted()),
        child: Sheet(
          initialOffset: SheetOffset(0.9),
          snapGrid: const SheetSnapGrid(snaps: [SheetOffset(0.55), SheetOffset(.8)]),
          decoration: MaterialSheetDecoration(
            size: SheetSize.fit,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            clipBehavior: Clip.antiAlias,
            color: Theme.of(modalContext).scaffoldBackgroundColor,
          ),
          scrollConfiguration: const SheetScrollConfiguration(),
          child: const _PrivacyPolicyModalSheetList(),
        ),
      ),
    ),
  );
}

class _PrivacyPolicyModalSheetList extends StatelessWidget {
  const _PrivacyPolicyModalSheetList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
      buildWhen: (p, c) => p.status != c.status || p.markdown != c.markdown,
      builder: (context, state) {
        // final header = _PrivacyPolicyModalHeader(
        //   title: context.l10n.termsLink,
        //   onClose: () {
        //     Gaimon.light();
        //     Navigator.of(context).pop();
        //   },
        // );

        switch (state.status) {
          case PrivacyPolicyStatus.initial:
          case PrivacyPolicyStatus.loading:
            if (state.markdown == null) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  // header,
                  const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                // header,
                PrivacyPolicyMarkdownView(markdown: state.markdown!),
              ],
            );
          case PrivacyPolicyStatus.success:
            final md = state.markdown;
            if (md == null || md.isEmpty) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  // header,
                  const SizedBox(height: 48),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                // header,
                PrivacyPolicyMarkdownView(markdown: md),
              ],
            );
          case PrivacyPolicyStatus.failure:
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                // header,
                SizedBox(
                  height: 380,
                  child: TgsFailureContent(message: context.l10n.aboutUsLoadError, onRetry: () => context.read<PrivacyPolicyBloc>().add(const PrivacyPolicyRetryRequested())),
                ),
              ],
            );
        }
      },
    );
  }
}

class _PrivacyPolicyModalHeader extends StatelessWidget {
  const _PrivacyPolicyModalHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: colors.stroke, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 44),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.heading6.copyWith(color: colors.text),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(22),
                  child: Ink(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.onContainer,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.stroke),
                    ),
                    child: Icon(LucideIcons.x, size: 22, color: colors.text),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
