import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/bloc/edit_information_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/screens/edit_information_screen_mixin.dart';

class EditInformationScreen extends StatefulWidget {
  const EditInformationScreen({super.key, this.seedUser});

  /// Profil ekranidan kelganda API qayta chaqirilmasin.
  final ProfileUserModel? seedUser;

  @override
  State<EditInformationScreen> createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> with EditInformationScreenMixin<EditInformationScreen> {
  @override
  void initState() {
    super.initState();
    initEditInformationControllers();
  }

  @override
  void dispose() {
    disposeEditInformationControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditInformationBloc>()..add(EditInformationStarted(seedUser: widget.seedUser)),
      child: Scaffold(
        backgroundColor: context.appColors.background,
        body: SafeArea(
          // left: false,
          // right: false,
          // bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    AppBackButton(onTap: () => onEditInformationBackTap(context)),
                    Expanded(
                      child: Text(
                        context.l10n.profileInformationTitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.heading6.copyWith(color: context.appColors.text),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocConsumer<EditInformationBloc, EditInformationState>(
                  listenWhen: (previous, current) {
                    if (current.saveError != null && current.saveError != previous.saveError) {
                      return true;
                    }
                    if (current.noticeSeq != previous.noticeSeq && current.notice != EditInformationNotice.none) {
                      return true;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    if (state.saveError != null) {
                      editInformationBlocListener(context, state);
                      return;
                    }
                    editInformationNoticeListener(context, state);
                  },
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.user != current.user ||
                      previous.isSaving != current.isSaving ||
                      previous.isPhotoUploading != current.isPhotoUploading ||
                      previous.localAvatarFilePath != current.localAvatarFilePath ||
                      previous.uploadedPhotoFilename != current.uploadedPhotoFilename ||
                      previous.selectedBadgeId != current.selectedBadgeId ||
                      previous.badgeCatalog != current.badgeCatalog,
                  builder: (context, state) {
                    switch (state.status) {
                      case EditInformationStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case EditInformationStatus.failure:
                        return TgsFailureContent(
                          message: state.loadMessage ?? '',
                          onRetry: () => context.read<EditInformationBloc>().add(EditInformationStarted(seedUser: widget.seedUser)),
                        );
                      case EditInformationStatus.ready:
                      case EditInformationStatus.initial:
                        if (state.user != null) {
                          return buildEditInformationBody(context, state: state);
                        }
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
