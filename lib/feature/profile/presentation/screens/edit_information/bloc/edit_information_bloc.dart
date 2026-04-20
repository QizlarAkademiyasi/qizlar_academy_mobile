import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/enum/education_type.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/data/location_data_loader.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/profile_badge_catalog_loader.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

part 'edit_information_event.dart';
part 'edit_information_state.dart';

class EditInformationBloc extends Bloc<EditInformationEvent, EditInformationState> {
  EditInformationBloc(this._repository, this._locationLoader) : super(const EditInformationState()) {
    on<EditInformationStarted>(_onStarted);
    on<EditInformationSaveRequested>(_onSaveRequested);
    on<EditInformationPhotoUploadRequested>(_onPhotoUploadRequested);
    on<EditInformationBadgeSelected>(_onBadgeSelected);
    on<EditInformationNoticeAcknowledged>(_onNoticeAcknowledged);
    on<EditInformationRegionSelected>(_onRegionSelected);
    on<EditInformationDistrictSelected>(_onDistrictSelected);
    on<EditInformationNeighborhoodSelected>(_onNeighborhoodSelected);
    on<EditInformationBirthdaySelected>(_onBirthdaySelected);
    on<EditInformationEducationTypeSelected>(_onEducationTypeSelected);
  }

  final ProfileRepository _repository;
  final LocationDataLoader _locationLoader;

  Future<void> _onStarted(
    EditInformationStarted event,
    Emitter<EditInformationState> emit,
  ) async {
    if (event.seedUser != null) {
      final u = event.seedUser!;
      try {
        final results = await Future.wait([
          ProfileBadgeCatalogLoader.load(),
          _locationLoader.loadRegions(),
        ]);
        final catalog = results[0] as List<ProfileBadgeDefinition>;
        final regions = results[1] as List<RegionModel>;
        final badgeId = ProfileBadgeCatalogLoader.coerceSelection(u.badgeId, catalog);
        final locationState = await _resolveUserLocation(u, regions);
        emit(
          state.copyWith(
            status: EditInformationStatus.ready,
            user: u,
            baselineUser: u,
            badgeCatalog: catalog,
            selectedBadgeId: badgeId,
            regions: regions,
            districts: locationState.districts,
            neighborhoods: locationState.neighborhoods,
            selectedRegion: locationState.region,
            selectedDistrict: locationState.district,
            selectedNeighborhood: locationState.neighborhood,
            baselineRegion: locationState.region,
            baselineDistrict: locationState.district,
            baselineNeighborhood: locationState.neighborhood,
            selectedBirthday: u.birthday,
            selectedEducationType: u.educationType,
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
            selectedBirthday: u.birthday,
            selectedEducationType: u.educationType,
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
      final results = await Future.wait([
        ProfileBadgeCatalogLoader.load(),
        _repository.getProfileOverview(),
        _locationLoader.loadRegions(),
      ]);
      final catalog = results[0] as List<ProfileBadgeDefinition>;
      final overview = results[1] as ProfileOverviewModel;
      final regions = results[2] as List<RegionModel>;
      final badgeId = ProfileBadgeCatalogLoader.coerceSelection(
        overview.user.badgeId,
        catalog,
      );
      final locationState = await _resolveUserLocation(overview.user, regions);
      emit(
        state.copyWith(
          status: EditInformationStatus.ready,
          user: overview.user,
          baselineUser: overview.user,
          badgeCatalog: catalog,
          selectedBadgeId: badgeId,
          regions: regions,
          districts: locationState.districts,
          neighborhoods: locationState.neighborhoods,
          selectedRegion: locationState.region,
          selectedDistrict: locationState.district,
          selectedNeighborhood: locationState.neighborhood,
          baselineRegion: locationState.region,
          baselineDistrict: locationState.district,
          baselineNeighborhood: locationState.neighborhood,
          selectedBirthday: overview.user.birthday,
          selectedEducationType: overview.user.educationType,
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
          clearLoadMessage: true,
        ),
      );
    }
  }

  /// Foydalanuvchining mavjud manzil ma'lumotlariga ko'ra region/district/neighborhood ni topadi.
  ///
  /// API ba'zan `id` o'rniga JSON dagi `kod` (SOATO) qiymatini yuboradi — ikkalasini ham sinaymiz.
  /// ID mos kelmasa, backend qaytargan nom bilan (trim, case-insensitive) qidiramiz.
  Future<_ResolvedLocation> _resolveUserLocation(
    ProfileUserModel user,
    List<RegionModel> regions,
  ) async {
    RegionModel? region;
    DistrictModel? district;
    NeighborhoodModel? neighborhood;
    var districts = <DistrictModel>[];
    var neighborhoods = <NeighborhoodModel>[];

    region = _resolveRegionMatch(regions, user);
    if (region != null) {
      districts = await _locationLoader.getDistrictsByRegion(region.id);
      district = _resolveDistrictMatch(districts, user);
      if (district != null) {
        neighborhoods = await _locationLoader.getNeighborhoodsByDistrict(district.id);
        neighborhood = _resolveNeighborhoodMatch(neighborhoods, user);
      }
    }
    return _ResolvedLocation(
      region: region,
      district: district,
      neighborhood: neighborhood,
      districts: districts,
      neighborhoods: neighborhoods,
    );
  }

  RegionModel? _resolveRegionMatch(List<RegionModel> regions, ProfileUserModel user) {
    if (user.regionId > 0) {
      final byId = regions.where((r) => r.id == user.regionId).firstOrNull;
      if (byId != null) return byId;
      final byKod = regions.where((r) => r.kod != 0 && r.kod == user.regionId).firstOrNull;
      if (byKod != null) return byKod;
    }
    return _matchByName(regions, user.regionName, (r) => r.name);
  }

  DistrictModel? _resolveDistrictMatch(List<DistrictModel> districts, ProfileUserModel user) {
    if (user.districtId > 0) {
      final byId = districts.where((d) => d.id == user.districtId).firstOrNull;
      if (byId != null) return byId;
      final byKod = districts.where((d) => d.kod != 0 && d.kod == user.districtId).firstOrNull;
      if (byKod != null) return byKod;
    }
    return _matchByName(districts, user.districtName, (d) => d.name);
  }

  NeighborhoodModel? _resolveNeighborhoodMatch(List<NeighborhoodModel> neighborhoods, ProfileUserModel user) {
    if (user.neighborhoodId > 0) {
      final byId = neighborhoods.where((n) => n.id == user.neighborhoodId).firstOrNull;
      if (byId != null) return byId;
      final byKod = neighborhoods.where((n) => n.kod != 0 && n.kod == user.neighborhoodId).firstOrNull;
      if (byKod != null) return byKod;
    }
    return _matchByName(neighborhoods, user.neighborhoodName, (n) => n.name);
  }

  T? _matchByName<T>(List<T> items, String rawName, String Function(T) nameOf) {
    final needle = rawName.trim().toLowerCase();
    if (needle.isEmpty) return null;
    return items.where((e) => nameOf(e).trim().toLowerCase() == needle).firstOrNull;
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
        occupation: event.occupation.trim(),
        uploadedPhotoFilename: state.uploadedPhotoFilename,
        selectedBadgeId: state.selectedBadgeId,
        selectedRegion: state.selectedRegion,
        selectedDistrict: state.selectedDistrict,
        selectedNeighborhood: state.selectedNeighborhood,
        baselineRegion: state.baselineRegion,
        baselineDistrict: state.baselineDistrict,
        baselineNeighborhood: state.baselineNeighborhood,
        selectedBirthday: state.selectedBirthday,
        selectedEducationType: state.selectedEducationType,
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
      final locationState = await _resolveUserLocation(overview.user, state.regions);
      emit(
        state.copyWith(
          isSaving: false,
          user: overview.user,
          baselineUser: overview.user,
          selectedBadgeId: nextBadgeId,
          selectedRegion: locationState.region,
          selectedDistrict: locationState.district,
          selectedNeighborhood: locationState.neighborhood,
          baselineRegion: locationState.region,
          baselineDistrict: locationState.district,
          baselineNeighborhood: locationState.neighborhood,
          districts: locationState.districts,
          neighborhoods: locationState.neighborhoods,
          selectedBirthday: overview.user.birthday,
          selectedEducationType: overview.user.educationType,
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
          clearSaveError: true,
          notice: EditInformationNotice.saveFailed,
          noticeSeq: state.noticeSeq + 1,
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

  Future<void> _onRegionSelected(
    EditInformationRegionSelected event,
    Emitter<EditInformationState> emit,
  ) async {
    emit(state.copyWith(
      selectedRegion: event.region,
      clearDistrict: true,
      clearNeighborhood: true,
      districts: const [],
      neighborhoods: const [],
    ));
    try {
      final districts = await _locationLoader.getDistrictsByRegion(event.region.id);
      emit(state.copyWith(districts: districts));
    } catch (e, st) {
      AppLogger.e('EditInformationBloc: districts yuklashda xato', error: e, stackTrace: st);
    }
  }

  Future<void> _onDistrictSelected(
    EditInformationDistrictSelected event,
    Emitter<EditInformationState> emit,
  ) async {
    emit(state.copyWith(
      selectedDistrict: event.district,
      clearNeighborhood: true,
      neighborhoods: const [],
    ));
    try {
      final neighborhoods = await _locationLoader.getNeighborhoodsByDistrict(event.district.id);
      emit(state.copyWith(neighborhoods: neighborhoods));
    } catch (e, st) {
      AppLogger.e('EditInformationBloc: neighborhoods yuklashda xato', error: e, stackTrace: st);
    }
  }

  void _onNeighborhoodSelected(
    EditInformationNeighborhoodSelected event,
    Emitter<EditInformationState> emit,
  ) {
    emit(state.copyWith(selectedNeighborhood: event.neighborhood));
  }

  void _onBirthdaySelected(
    EditInformationBirthdaySelected event,
    Emitter<EditInformationState> emit,
  ) {
    emit(state.copyWith(selectedBirthday: event.birthday));
  }

  void _onEducationTypeSelected(
    EditInformationEducationTypeSelected event,
    Emitter<EditInformationState> emit,
  ) {
    emit(state.copyWith(selectedEducationType: event.educationType));
  }
}

class _ResolvedLocation {
  const _ResolvedLocation({
    this.region,
    this.district,
    this.neighborhood,
    this.districts = const [],
    this.neighborhoods = const [],
  });

  final RegionModel? region;
  final DistrictModel? district;
  final NeighborhoodModel? neighborhood;
  final List<DistrictModel> districts;
  final List<NeighborhoodModel> neighborhoods;
}
