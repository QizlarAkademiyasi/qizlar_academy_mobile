import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/bloc/privacy_policy_bloc.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/components/privacy_policy_markdown_view.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/screens/privacy_policy_screen_mixin.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> with PrivacyPolicyScreenMixin<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrivacyPolicyBloc>()..add(const PrivacyPolicyStarted()),
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: context.appColors.background,
          leading: AppBackButton(onTap: () => onPrivacyPolicyBackTap(context)),
          title: Text(context.l10n.profileMenuPrivacy, style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
          centerTitle: true,
        ),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
            buildWhen: (p, c) => p.status != c.status || p.markdown != c.markdown,
            builder: (context, state) {
              switch (state.status) {
                case PrivacyPolicyStatus.initial:
                case PrivacyPolicyStatus.loading:
                  if (state.markdown == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _PrivacyPolicyScrollBody(markdown: state.markdown!);
                case PrivacyPolicyStatus.success:
                  final md = state.markdown;
                  if (md == null || md.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return _PrivacyPolicyScrollBody(markdown: md);
                case PrivacyPolicyStatus.failure:
                  return TgsFailureContent(message: context.l10n.aboutUsLoadError, onRetry: () => context.read<PrivacyPolicyBloc>().add(const PrivacyPolicyRetryRequested()));
              }
            },
          ),
        ),
      ),
    );
  }
}

class _PrivacyPolicyScrollBody extends StatelessWidget {
  const _PrivacyPolicyScrollBody({required this.markdown});

  final String markdown;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      physics: const BouncingScrollPhysics(),
      child: PrivacyPolicyMarkdownView(markdown: markdown),
    );
  }
}
