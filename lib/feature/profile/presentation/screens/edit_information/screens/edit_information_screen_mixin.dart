import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/format/phone_display_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/profile_edit_pending_patch.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_pick_result.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_picker.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/bloc/edit_information_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/components/edit_information_avatar.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/components/edit_information_form.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/services/profile_avatar_refresh_notifier.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/components/edit_information_status_strip.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/components/edit_information_unsaved_dialog.dart';

/// Profil ma'lumotlari tahriri: navigatsiya, rasm tanlash, saqlash, controller sinxroni.
mixin EditInformationScreenMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController phoneNationalController;
  String? _fieldsSyncedSignature;
  late final VoidCallback _nameFieldsListener;
  bool _applyingSyncedFields = false;

  void initEditInformationControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneNationalController = TextEditingController();
    _nameFieldsListener = () {
      if (_applyingSyncedFields || !mounted) return;
      setState(() {});
    };
    firstNameController.addListener(_nameFieldsListener);
    lastNameController.addListener(_nameFieldsListener);
  }

  void disposeEditInformationControllers() {
    firstNameController.removeListener(_nameFieldsListener);
    lastNameController.removeListener(_nameFieldsListener);
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNationalController.dispose();
  }

  void syncEditInformationFieldsIfNeeded(ProfileUserModel user) {
    final signature = '${user.userId}|${user.firstName}|${user.lastName}|${user.phoneNumber}|${user.avatarUrl}|${user.badgeId}';
    if (_fieldsSyncedSignature == signature) return;
    _fieldsSyncedSignature = signature;
    _applyingSyncedFields = true;
    try {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneNationalController.text = formatUzbekNationalDigitsForDisplay(extractUzbekNationalDigits(user.phoneNumber));
    } finally {
      _applyingSyncedFields = false;
    }
  }

  bool editInformationHasUnsavedChanges(EditInformationState state) {
    final user = state.user;
    if (user == null) return false;
    final baseline = state.baselineUser ?? user;
    final local = state.localAvatarFilePath?.trim() ?? '';
    if (local.isNotEmpty) return true;
    return profileEditHasPendingPatch(
      baseline: baseline,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      uploadedPhotoFilename: state.uploadedPhotoFilename,
      selectedBadgeId: state.selectedBadgeId,
    );
  }

  Future<void> onEditInformationBackTap(BuildContext context) async {
    Gaimon.light();
    final bloc = context.read<EditInformationBloc>();
    final state = bloc.state;

    if (state.status == EditInformationStatus.loading || state.status == EditInformationStatus.failure || state.user == null) {
      if (context.mounted) context.pop(false);
      return;
    }

    if (state.isSaving) {
      return;
    }

    if (!editInformationHasUnsavedChanges(state)) {
      if (context.mounted) context.pop(false);
      return;
    }

    final choice = await showEditInformationUnsavedDialog(context);
    if (!context.mounted) return;

    switch (choice) {
      case EditInformationUnsavedResult.save:
        onEditInformationSaveTap(context);
        return;
      case EditInformationUnsavedResult.discard:
        context.pop(false);
        return;
      case EditInformationUnsavedResult.cancelled:
      case null:
        return;
    }
  }

  Future<void> onEditInformationCameraTap(BuildContext context) async {
    final pickResult = await getIt<ProfilePhotoPicker>().pickProfileAvatarFromGallery(context);
    if (!context.mounted) return;
    switch (pickResult) {
      case ProfilePhotoPickSuccess(:final localFilePath):
        context.read<EditInformationBloc>().add(EditInformationPhotoUploadRequested(localFilePath));
      case ProfilePhotoPickCanceled():
        return;
      case ProfilePhotoPickPermissionDenied():
        AppToast.info(context, message: context.l10n.profileInformationPhotoPermissionDenied);
      case ProfilePhotoPickFailure():
        AppToast.error(context, message: context.l10n.profileInformationPhotoPickFailed);
    }
  }

  void onEditInformationSaveTap(BuildContext context) {
    final l10n = context.l10n;
    final first = firstNameController.text.trim();
    final last = lastNameController.text.trim();
    if (first.isEmpty || last.isEmpty) {
      AppToast.error(context, message: l10n.profileInformationNameRequired);
      return;
    }
    context.read<EditInformationBloc>().add(EditInformationSaveRequested(firstName: first, lastName: last));
  }

  void editInformationNoticeListener(BuildContext context, EditInformationState state) {
    final bloc = context.read<EditInformationBloc>();
    switch (state.notice) {
      case EditInformationNotice.saveFailed:
        AppToast.error(context, message: context.l10n.editProfileSaveError);
        bloc.add(const EditInformationNoticeAcknowledged());
        return;
      case EditInformationNotice.saveSuccess:
        onEditInformationSaveSuccess(context);
        return;
      case EditInformationNotice.nothingToSave:
        AppToast.info(context, message: context.l10n.profileInformationNoChanges);
        bloc.add(const EditInformationNoticeAcknowledged());
        return;
      case EditInformationNotice.photoUploadFailed:
        AppToast.error(context, message: context.l10n.profileInformationPhotoUploadFailed);
        bloc.add(const EditInformationNoticeAcknowledged());
        return;
      case EditInformationNotice.none:
        return;
    }
  }

  void onEditInformationSaveSuccess(BuildContext context) {
    getIt<ProfileAvatarRefreshNotifier>().bumpAvatarCache();
    AppToast.success(context, message: context.l10n.profileInformationSaveSuccess);
    context.pop(true);
  }

  Widget buildEditInformationBody(BuildContext context, {required EditInformationState state}) {
    final user = state.user;
    if (user == null) {
      return const SizedBox.shrink();
    }
    syncEditInformationFieldsIfNeeded(user);

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final l10n = context.l10n;
    final saveBlocked = state.isSaving || state.isPhotoUploading;
    final baseline = state.baselineUser ?? user;
    final first = firstNameController.text.trim();
    final last = lastNameController.text.trim();
    final hasPendingPatch = profileEditHasPendingPatch(
      baseline: baseline,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      uploadedPhotoFilename: state.uploadedPhotoFilename,
      selectedBadgeId: state.selectedBadgeId,
    );
    final canSave = hasPendingPatch && first.isNotEmpty && last.isNotEmpty && !saveBlocked;

    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: AppPadding.paddingHorizontalMd,
                  child: EditInformationAvatar(user: user, localFilePath: state.localAvatarFilePath, isBusy: state.isPhotoUploading, onCameraTap: () => onEditInformationCameraTap(context)),
                ),
                const SizedBox(height: 24),
                if (state.badgeCatalog.isNotEmpty) ...[
                  Padding(
                    padding: AppPadding.paddingHorizontalMd,
                    child: Text(l10n.profileInformationStatusTitle, style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.secondaryGrey)),
                  ),
                  const SizedBox(height: 10),
                  EditInformationStatusStrip(
                    badges: state.badgeCatalog,
                    selectedBadgeId: state.selectedBadgeId,
                    onSelected: (id) => context.read<EditInformationBloc>().add(EditInformationBadgeSelected(id)),
                  ),
                  const SizedBox(height: 28),
                ],
                Padding(
                  padding: AppPadding.paddingHorizontalMd,
                  child: EditInformationForm(firstNameController: firstNameController, lastNameController: lastNameController, phoneNationalController: phoneNationalController),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: AppPadding.paddingMd,
            child: PrimaryButton.elevated(label: l10n.profileInformationSave, isLoading: state.isSaving, onPressed: canSave ? () => onEditInformationSaveTap(context) : null),
          ),
        ),
      ],
    );
  }
}
