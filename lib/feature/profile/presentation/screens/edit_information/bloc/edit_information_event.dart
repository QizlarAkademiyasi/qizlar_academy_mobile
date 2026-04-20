part of 'edit_information_bloc.dart';

sealed class EditInformationEvent extends Equatable {
  const EditInformationEvent();

  @override
  List<Object?> get props => [];
}

final class EditInformationStarted extends EditInformationEvent {
  const EditInformationStarted({this.seedUser});

  final ProfileUserModel? seedUser;

  @override
  List<Object?> get props => [seedUser];
}

final class EditInformationSaveRequested extends EditInformationEvent {
  const EditInformationSaveRequested({
    required this.firstName,
    required this.lastName,
    required this.occupation,
  });

  final String firstName;
  final String lastName;
  final String occupation;

  @override
  List<Object?> get props => [firstName, lastName, occupation];
}

final class EditInformationPhotoUploadRequested extends EditInformationEvent {
  const EditInformationPhotoUploadRequested(this.localFilePath);

  final String localFilePath;

  @override
  List<Object?> get props => [localFilePath];
}

final class EditInformationBadgeSelected extends EditInformationEvent {
  const EditInformationBadgeSelected(this.badgeId);

  final int badgeId;

  @override
  List<Object?> get props => [badgeId];
}

final class EditInformationNoticeAcknowledged extends EditInformationEvent {
  const EditInformationNoticeAcknowledged();
}

final class EditInformationRegionSelected extends EditInformationEvent {
  const EditInformationRegionSelected(this.region);

  final RegionModel region;

  @override
  List<Object?> get props => [region];
}

final class EditInformationDistrictSelected extends EditInformationEvent {
  const EditInformationDistrictSelected(this.district);

  final DistrictModel district;

  @override
  List<Object?> get props => [district];
}

final class EditInformationNeighborhoodSelected extends EditInformationEvent {
  const EditInformationNeighborhoodSelected(this.neighborhood);

  final NeighborhoodModel neighborhood;

  @override
  List<Object?> get props => [neighborhood];
}

final class EditInformationBirthdaySelected extends EditInformationEvent {
  const EditInformationBirthdaySelected(this.birthday);

  final DateTime birthday;

  @override
  List<Object?> get props => [birthday];
}

final class EditInformationEducationTypeSelected extends EditInformationEvent {
  const EditInformationEducationTypeSelected(this.educationType);

  final EducationType educationType;

  @override
  List<Object?> get props => [educationType];
}
