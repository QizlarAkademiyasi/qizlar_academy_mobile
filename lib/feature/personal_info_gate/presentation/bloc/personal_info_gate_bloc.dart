import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/data/location_data_loader.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/data/personal_info_gate_checker.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/config/enum/education_type.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_datasource.dart';

part 'personal_info_gate_event.dart';
part 'personal_info_gate_state.dart';

class PersonalInfoGateBloc extends Bloc<PersonalInfoGateEvent, PersonalInfoGateState> {
  PersonalInfoGateBloc(this._locationLoader, this._profileDatasource, this._checker) : super(const PersonalInfoGateState()) {
    on<PersonalInfoGateStarted>(_onStarted);
    on<PersonalInfoGateRegionSelected>(_onRegionSelected);
    on<PersonalInfoGateDistrictSelected>(_onDistrictSelected);
    on<PersonalInfoGateNeighborhoodSelected>(_onNeighborhoodSelected);
    on<PersonalInfoGateBirthdaySelected>(_onBirthdaySelected);
    on<PersonalInfoGateEducationTypeSelected>(_onEducationTypeSelected);
    on<PersonalInfoGateStepSubmitted>(_onStepSubmitted);
  }

  final LocationDataLoader _locationLoader;
  final ProfileDatasource _profileDatasource;
  final PersonalInfoGateChecker _checker;

  Future<void> _onStarted(PersonalInfoGateStarted event, Emitter<PersonalInfoGateState> emit) async {
    emit(state.copyWith(status: PersonalInfoGateStatus.loading, currentStep: event.step));
    try {
      if (event.step == 0) {
        final regions = await _locationLoader.loadRegions();
        emit(state.copyWith(status: PersonalInfoGateStatus.ready, regions: regions));
      } else {
        emit(state.copyWith(status: PersonalInfoGateStatus.ready));
      }
    } catch (e, st) {
      AppLogger.e('PersonalInfoGateBloc: start xato (step=${event.step})', error: e, stackTrace: st);
      emit(state.copyWith(status: PersonalInfoGateStatus.failure));
    }
  }

  Future<void> _onRegionSelected(PersonalInfoGateRegionSelected event, Emitter<PersonalInfoGateState> emit) async {
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
      AppLogger.e('PersonalInfoGateBloc: districts yuklashda xato', error: e, stackTrace: st);
    }
  }

  Future<void> _onDistrictSelected(PersonalInfoGateDistrictSelected event, Emitter<PersonalInfoGateState> emit) async {
    emit(state.copyWith(
      selectedDistrict: event.district,
      clearNeighborhood: true,
      neighborhoods: const [],
    ));
    try {
      final neighborhoods = await _locationLoader.getNeighborhoodsByDistrict(event.district.id);
      emit(state.copyWith(neighborhoods: neighborhoods));
    } catch (e, st) {
      AppLogger.e('PersonalInfoGateBloc: neighborhoods yuklashda xato', error: e, stackTrace: st);
    }
  }

  void _onNeighborhoodSelected(PersonalInfoGateNeighborhoodSelected event, Emitter<PersonalInfoGateState> emit) {
    emit(state.copyWith(selectedNeighborhood: event.neighborhood));
  }

  void _onBirthdaySelected(PersonalInfoGateBirthdaySelected event, Emitter<PersonalInfoGateState> emit) {
    emit(state.copyWith(birthday: event.birthday));
  }

  void _onEducationTypeSelected(PersonalInfoGateEducationTypeSelected event, Emitter<PersonalInfoGateState> emit) {
    emit(state.copyWith(educationType: event.type));
  }

  /// Joriy bosqichning ma'lumotlarini PATCH qiladi va keshga yozadi.
  Future<void> _onStepSubmitted(PersonalInfoGateStepSubmitted event, Emitter<PersonalInfoGateState> emit) async {
    emit(state.copyWith(status: PersonalInfoGateStatus.submitting));
    try {
      final body = _buildPatchBody(state.currentStep);
      await _profileDatasource.patchUserMe(body);
      await _checker.markStepCompleted(state.currentStep);
      emit(state.copyWith(status: PersonalInfoGateStatus.success));
    } catch (e, st) {
      AppLogger.e('PersonalInfoGateBloc: step ${state.currentStep} submit xato', error: e, stackTrace: st);
      emit(state.copyWith(status: PersonalInfoGateStatus.failure));
    }
  }

  Map<String, dynamic> _buildPatchBody(int step) {
    switch (step) {
      case 0:
        final region = state.selectedRegion!;
        final district = state.selectedDistrict!;
        final neighborhood = state.selectedNeighborhood!;
        return <String, dynamic>{
          'regionId': region.id,
          'districtId': district.id,
          'neighborhoodId': neighborhood.id,
          'countryId': region.countryId,
        };
      case 1:
        final birthday = state.birthday!;
        return {
          'birthday': '${birthday.year}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}',
        };
      case 2:
        return {
          'educationId': state.educationType!.patchEducationId,
        };
      default:
        return {};
    }
  }
}
