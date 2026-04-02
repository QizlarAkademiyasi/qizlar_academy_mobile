import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/profile_badge_catalog_loader.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

part 'edit_information_event.dart';
part 'edit_information_state.dart';

class EditInformationBloc extends Bloc<EditInformationEvent, EditInformationState> {
  EditInformationBloc(this._repository) : super(const EditInformationState()) {
    on<EditInformationStarted>(_onStarted);
    on<EditInformationSaveRequested>(_onSaveRequested);
    on<EditInformationPhotoUploadRequested>(_onPhotoUploadRequested);
    on<EditInformationBadgeSelected>(_onBadgeSelected);
    on<EditInformationNoticeAcknowledged>(_onNoticeAcknowledged);
  }

  final ProfileRepository _repository;

  Future<void> _onStarted(
    EditInformationStarted event,
    Emitter<EditInformationState> emit,
  ) async {
    if (event.seedUser != null) {
      final u = event.seedUser!;
      try {
        final catalog = await ProfileBadgeCatalogLoader.load();
        final badgeId = ProfileBadgeCatalogLoader.coerceSelection(u.badgeId, catalog);
        emit(
          state.copyWith(
            status: EditInformationStatus.ready,
            user: u,
            baselineUser: u,
            badgeCatalog: catalog,
            selectedBadgeId: badgeId,
            clearLoadMessage: true,
            clearSaveError: true,
            clearLocalAvatar: true,
            clearUploadedPhoto: true,
            clearNotice: true,
          ),
        );
      } catch (e, st) {
        AppLogger.e(
          'EditInformationBloc: badge catalog load failed',
          error: e,
          stackTrace: st,
        );
        emit(
          state.copyWith(
            status: EditInformationStatus.ready,
            user: u,
            baselineUser: u,
            selectedBadgeId: u.badgeId,
            clearLoadMessage: true,
            clearSaveError: true,
            clearLocalAvatar: true,
            clearUploadedPhoto: true,
            clearNotice: true,
          ),
        );
      }
      return;
    }

    emit(
      state.copyWith(
        status: EditInformationStatus.loading,
        clearLoadMessage: true,
        clearSaveError: true,
        clearLocalAvatar: true,
        clearUploadedPhoto: true,
        clearNotice: true,
      ),
    );
    try {
      final catalog = await ProfileBadgeCatalogLoader.load();
      final overview = await _repository.getProfileOverview();
      final badgeId = ProfileBadgeCatalogLoader.coerceSelection(
        overview.user.badgeId,
        catalog,
      );
      emit(
        state.copyWith(
          status: EditInformationStatus.ready,
          user: overview.user,
          baselineUser: overview.user,
          badgeCatalog: catalog,
          selectedBadgeId: badgeId,
          clearLoadMessage: true,
        ),
      );
    } catch (e, st) {
      AppLogger.e(
        'EditInformationBloc: load failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          status: EditInformationStatus.failure,
          loadMessage: 'Profil ma’lumotlarini yuklashda xatolik.',
        ),
      );
    }
  }

  Future<void> _onPhotoUploadRequested(
    EditInformationPhotoUploadRequested event,
    Emitter<EditInformationState> emit,
  ) async {
    emit(
      state.copyWith(
        isPhotoUploading: true,
        localAvatarFilePath: event.localFilePath,
        clearSaveError: true,
        clearNotice: true,
      ),
    );
    try {
      final filename = await _repository.uploadProfilePhoto(event.localFilePath);
      emit(
        state.copyWith(
          isPhotoUploading: false,
          uploadedPhotoFilename: filename,
        ),
      );
    } catch (e, st) {
      AppLogger.e(
        'EditInformationBloc: photo upload failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          isPhotoUploading: false,
          clearLocalAvatar: true,
          clearUploadedPhoto: true,
          notice: EditInformationNotice.photoUploadFailed,
          noticeSeq: state.noticeSeq + 1,
        ),
      );
    }
  }

  Future<void> _onSaveRequested(
    EditInformationSaveRequested event,
    Emitter<EditInformationState> emit,
  ) async {
    final current = state.user;
    final baseline = state.baselineUser ?? current;
    if (current == null || baseline == null) return;

    emit(
      state.copyWith(
        isSaving: true,
        clearSaveError: true,
        clearNotice: true,
      ),
    );
    try {
      final overview = await _repository.patchMyProfileIfChanged(
        baseline: baseline,
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        uploadedPhotoFilename: state.uploadedPhotoFilename,
        selectedBadgeId: state.selectedBadgeId,
      );
      if (overview == null) {
        emit(
          state.copyWith(
            isSaving: false,
            notice: EditInformationNotice.nothingToSave,
            noticeSeq: state.noticeSeq + 1,
          ),
        );
        return;
      }
      final nextBadgeId = ProfileBadgeCatalogLoader.coerceSelection(
        overview.user.badgeId,
        state.badgeCatalog,
      );
      emit(
        state.copyWith(
          isSaving: false,
          user: overview.user,
          baselineUser: overview.user,
          selectedBadgeId: nextBadgeId,
          clearLocalAvatar: true,
          clearUploadedPhoto: true,
          notice: EditInformationNotice.saveSuccess,
          noticeSeq: state.noticeSeq + 1,
        ),
      );
    } catch (e, st) {
      AppLogger.e(
        'EditInformationBloc: save failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          isSaving: false,
          saveError: 'Ma’lumotlarni saqlab bo‘lmadi. Qayta urinib ko‘ring.',
        ),
      );
    }
  }

  void _onBadgeSelected(
    EditInformationBadgeSelected event,
    Emitter<EditInformationState> emit,
  ) {
    emit(state.copyWith(selectedBadgeId: event.badgeId));
  }

  void _onNoticeAcknowledged(
    EditInformationNoticeAcknowledged event,
    Emitter<EditInformationState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }
}
