part of 'edit_information_bloc.dart';

enum EditInformationStatus { initial, loading, ready, failure }

enum EditInformationNotice {
  none,
  saveSuccess,
  nothingToSave,
  photoUploadFailed,
}

class EditInformationState extends Equatable {
  const EditInformationState({
    this.status = EditInformationStatus.initial,
    this.user,
    this.baselineUser,
    this.loadMessage,
    this.saveError,
    this.isSaving = false,
    this.isPhotoUploading = false,
    this.localAvatarFilePath,
    this.uploadedPhotoFilename,
    this.badgeCatalog = const [],
    this.selectedBadgeId = 0,
    this.notice = EditInformationNotice.none,
    this.noticeSeq = 0,
  });

  final EditInformationStatus status;
  final ProfileUserModel? user;
  final ProfileUserModel? baselineUser;
  final String? loadMessage;
  final String? saveError;
  final bool isSaving;
  final bool isPhotoUploading;
  final String? localAvatarFilePath;
  final String? uploadedPhotoFilename;
  final List<ProfileBadgeDefinition> badgeCatalog;
  final int selectedBadgeId;
  final EditInformationNotice notice;
  final int noticeSeq;

  EditInformationState copyWith({
    EditInformationStatus? status,
    ProfileUserModel? user,
    ProfileUserModel? baselineUser,
    String? loadMessage,
    bool clearLoadMessage = false,
    String? saveError,
    bool clearSaveError = false,
    bool? isSaving,
    bool? isPhotoUploading,
    String? localAvatarFilePath,
    bool clearLocalAvatar = false,
    String? uploadedPhotoFilename,
    bool clearUploadedPhoto = false,
    List<ProfileBadgeDefinition>? badgeCatalog,
    int? selectedBadgeId,
    EditInformationNotice? notice,
    int? noticeSeq,
    bool clearNotice = false,
  }) {
    return EditInformationState(
      status: status ?? this.status,
      user: user ?? this.user,
      baselineUser: baselineUser ?? this.baselineUser,
      loadMessage: clearLoadMessage ? null : (loadMessage ?? this.loadMessage),
      saveError: clearSaveError ? null : (saveError ?? this.saveError),
      isSaving: isSaving ?? this.isSaving,
      isPhotoUploading: isPhotoUploading ?? this.isPhotoUploading,
      localAvatarFilePath: clearLocalAvatar
          ? null
          : (localAvatarFilePath ?? this.localAvatarFilePath),
      uploadedPhotoFilename: clearUploadedPhoto
          ? null
          : (uploadedPhotoFilename ?? this.uploadedPhotoFilename),
      badgeCatalog: badgeCatalog ?? this.badgeCatalog,
      selectedBadgeId: selectedBadgeId ?? this.selectedBadgeId,
      notice: clearNotice ? EditInformationNotice.none : (notice ?? this.notice),
      noticeSeq: noticeSeq ?? this.noticeSeq,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    baselineUser,
    loadMessage,
    saveError,
    isSaving,
    isPhotoUploading,
    localAvatarFilePath,
    uploadedPhotoFilename,
    badgeCatalog,
    selectedBadgeId,
    notice,
    noticeSeq,
  ];
}
