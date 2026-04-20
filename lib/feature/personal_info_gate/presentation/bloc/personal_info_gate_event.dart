part of 'personal_info_gate_bloc.dart';

sealed class PersonalInfoGateEvent extends Equatable {
  const PersonalInfoGateEvent();

  @override
  List<Object?> get props => [];
}

final class PersonalInfoGateStarted extends PersonalInfoGateEvent {
  const PersonalInfoGateStarted({required this.step});

  /// Ko'rsatiladigan bosqich raqami (0, 1, 2).
  final int step;

  @override
  List<Object?> get props => [step];
}

final class PersonalInfoGateRegionSelected extends PersonalInfoGateEvent {
  const PersonalInfoGateRegionSelected(this.region);
  final RegionModel region;

  @override
  List<Object?> get props => [region];
}

final class PersonalInfoGateDistrictSelected extends PersonalInfoGateEvent {
  const PersonalInfoGateDistrictSelected(this.district);
  final DistrictModel district;

  @override
  List<Object?> get props => [district];
}

final class PersonalInfoGateNeighborhoodSelected extends PersonalInfoGateEvent {
  const PersonalInfoGateNeighborhoodSelected(this.neighborhood);
  final NeighborhoodModel neighborhood;

  @override
  List<Object?> get props => [neighborhood];
}

final class PersonalInfoGateBirthdaySelected extends PersonalInfoGateEvent {
  const PersonalInfoGateBirthdaySelected(this.birthday);
  final DateTime birthday;

  @override
  List<Object?> get props => [birthday];
}

final class PersonalInfoGateEducationTypeSelected extends PersonalInfoGateEvent {
  const PersonalInfoGateEducationTypeSelected(this.type);
  final EducationType type;

  @override
  List<Object?> get props => [type];
}

/// "Davom etish" bosilganda — joriy bosqichni PATCH qiladi.
final class PersonalInfoGateStepSubmitted extends PersonalInfoGateEvent {
  const PersonalInfoGateStepSubmitted();
}
