import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/bloc/edit_information_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/screens/edit_information_screen_mixin.dart';

class EditInformationScreen extends StatelessWidget {
  const EditInformationScreen({super.key, this.seedUser});

  /// Profil ekranidan kelganda API qayta chaqirilmasin.
  final ProfileUserModel? seedUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<EditInformationBloc>()
            ..add(EditInformationStarted(seedUser: seedUser)),
      child: _EditInformationView(seedUser: seedUser),
    );
  }
}

class _EditInformationView extends StatefulWidget {
  const _EditInformationView({this.seedUser});

  final ProfileUserModel? seedUser;

  @override
  State<_EditInformationView> createState() => _EditInformationViewState();
}

class _EditInformationViewState extends State<_EditInformationView>
    with EditInformationScreenMixin<_EditInformationView> {
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(onEditInformationBackTap(context));
      },
      child: AppPageScaffold(
        title: context.l10n.profileInformationTitle,
        centerTitle: true,
        onBackTap: () => unawaited(onEditInformationBackTap(context)),
        body: BlocConsumer<EditInformationBloc, EditInformationState>(
          listenWhen: (previous, current) {
            if (current.noticeSeq != previous.noticeSeq &&
                current.notice != EditInformationNotice.none) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
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
              previous.badgeCatalog != current.badgeCatalog ||
              previous.regions != current.regions ||
              previous.districts != current.districts ||
              previous.neighborhoods != current.neighborhoods ||
              previous.selectedRegion != current.selectedRegion ||
              previous.selectedDistrict != current.selectedDistrict ||
              previous.selectedNeighborhood != current.selectedNeighborhood ||
              previous.selectedBirthday != current.selectedBirthday ||
              previous.selectedEducationType != current.selectedEducationType,
          builder: (context, state) {
            switch (state.status) {
              case EditInformationStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case EditInformationStatus.failure:
                return AppFailureState(
                  message: context.l10n.editProfileLoadError,
                  onRetry: () => context.read<EditInformationBloc>().add(
                    EditInformationStarted(seedUser: widget.seedUser),
                  ),
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
    );
  }
}
