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
  });

  final String firstName;
  final String lastName;

  @override
  List<Object?> get props => [firstName, lastName];
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
