part of 'personal_info_gate_bloc.dart';

enum PersonalInfoGateStatus { initial, loading, ready, submitting, success, failure }

class PersonalInfoGateState extends Equatable {
  const PersonalInfoGateState({
    this.status = PersonalInfoGateStatus.initial,
    this.currentStep = 0,
    this.regions = const [],
    this.districts = const [],
    this.neighborhoods = const [],
    this.selectedRegion,
    this.selectedDistrict,
    this.selectedNeighborhood,
    this.birthday,
    this.educationType,
  });

  final PersonalInfoGateStatus status;

  /// Ko'rsatilayotgan bosqich: 0 = Manzil, 1 = Tug'ilgan sana, 2 = Ta'lim turi
  final int currentStep;
  final List<RegionModel> regions;
  final List<DistrictModel> districts;
  final List<NeighborhoodModel> neighborhoods;
  final RegionModel? selectedRegion;
  final DistrictModel? selectedDistrict;
  final NeighborhoodModel? selectedNeighborhood;
  final DateTime? birthday;
  final EducationType? educationType;

  bool get isAddressStepValid => selectedRegion != null && selectedDistrict != null && selectedNeighborhood != null;

  bool get isBirthdayStepValid => birthday != null;

  bool get isEducationStepValid => educationType != null;

  bool get canContinue {
    switch (currentStep) {
      case 0:
        return isAddressStepValid;
      case 1:
        return isBirthdayStepValid;
      case 2:
        return isEducationStepValid;
      default:
        return false;
    }
  }

  PersonalInfoGateState copyWith({
    PersonalInfoGateStatus? status,
    int? currentStep,
    List<RegionModel>? regions,
    List<DistrictModel>? districts,
    List<NeighborhoodModel>? neighborhoods,
    RegionModel? selectedRegion,
    bool clearDistrict = false,
    DistrictModel? selectedDistrict,
    bool clearNeighborhood = false,
    NeighborhoodModel? selectedNeighborhood,
    DateTime? birthday,
    EducationType? educationType,
  }) {
    return PersonalInfoGateState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      neighborhoods: neighborhoods ?? this.neighborhoods,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      selectedDistrict: clearDistrict ? null : (selectedDistrict ?? this.selectedDistrict),
      selectedNeighborhood: clearNeighborhood ? null : (selectedNeighborhood ?? this.selectedNeighborhood),
      birthday: birthday ?? this.birthday,
      educationType: educationType ?? this.educationType,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    regions,
    districts,
    neighborhoods,
    selectedRegion,
    selectedDistrict,
    selectedNeighborhood,
    birthday,
    educationType,
  ];
}
