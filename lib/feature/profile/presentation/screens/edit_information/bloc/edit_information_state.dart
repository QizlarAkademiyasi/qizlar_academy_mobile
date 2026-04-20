part of 'edit_information_bloc.dart';

enum EditInformationStatus { initial, loading, ready, failure }

enum EditInformationNotice {
  none,
  saveSuccess,
  saveFailed,
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
    this.regions = const [],
    this.districts = const [],
    this.neighborhoods = const [],
    this.selectedRegion,
    this.selectedDistrict,
    this.selectedNeighborhood,
    this.baselineRegion,
    this.baselineDistrict,
    this.baselineNeighborhood,
    this.selectedBirthday,
    this.selectedEducationType,
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

  /// Manzil: viloyatlar ro'yxati.
  final List<RegionModel> regions;
  /// Manzil: tanlangan viloyatga tegishli tumanlar.
  final List<DistrictModel> districts;
  /// Manzil: tanlangan tumanga tegishli mahallalar.
  final List<NeighborhoodModel> neighborhoods;
  final RegionModel? selectedRegion;
  final DistrictModel? selectedDistrict;
  final NeighborhoodModel? selectedNeighborhood;
  /// Boshlang'ich resolve qilingan manzil modellari (unsaved changes tekshiruvi uchun).
  final RegionModel? baselineRegion;
  final DistrictModel? baselineDistrict;
  final NeighborhoodModel? baselineNeighborhood;
  final DateTime? selectedBirthday;
  final EducationType? selectedEducationType;

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
    List<RegionModel>? regions,
    List<DistrictModel>? districts,
    List<NeighborhoodModel>? neighborhoods,
    RegionModel? selectedRegion,
    bool clearRegion = false,
    DistrictModel? selectedDistrict,
    bool clearDistrict = false,
    NeighborhoodModel? selectedNeighborhood,
    bool clearNeighborhood = false,
    RegionModel? baselineRegion,
    DistrictModel? baselineDistrict,
    NeighborhoodModel? baselineNeighborhood,
    DateTime? selectedBirthday,
    EducationType? selectedEducationType,
    bool clearEducationType = false,
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
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      neighborhoods: neighborhoods ?? this.neighborhoods,
      selectedRegion: clearRegion ? null : (selectedRegion ?? this.selectedRegion),
      selectedDistrict: clearDistrict ? null : (selectedDistrict ?? this.selectedDistrict),
      selectedNeighborhood: clearNeighborhood ? null : (selectedNeighborhood ?? this.selectedNeighborhood),
      baselineRegion: baselineRegion ?? this.baselineRegion,
      baselineDistrict: baselineDistrict ?? this.baselineDistrict,
      baselineNeighborhood: baselineNeighborhood ?? this.baselineNeighborhood,
      selectedBirthday: selectedBirthday ?? this.selectedBirthday,
      selectedEducationType: clearEducationType ? null : (selectedEducationType ?? this.selectedEducationType),
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
    regions,
    districts,
    neighborhoods,
    selectedRegion,
    selectedDistrict,
    selectedNeighborhood,
    baselineRegion,
    baselineDistrict,
    baselineNeighborhood,
    selectedBirthday,
    selectedEducationType,
  ];
}
