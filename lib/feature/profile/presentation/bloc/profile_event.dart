part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

final class ProfileRetryRequested extends ProfileEvent {
  const ProfileRetryRequested();
}

final class ProfileNotificationsToggled extends ProfileEvent {
  const ProfileNotificationsToggled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class ProfileDarkModeToggled extends ProfileEvent {
  const ProfileDarkModeToggled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
