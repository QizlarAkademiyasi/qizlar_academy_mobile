part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, updating, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.overview,
    this.message,
    this.requiresRegistration = false,
  });

  final ProfileStatus status;
  final ProfileOverviewModel? overview;
  final String? message;
  final bool requiresRegistration;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileOverviewModel? overview,
    String? message,
    bool? requiresRegistration,
  }) {
    return ProfileState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      message: message,
      requiresRegistration: requiresRegistration ?? this.requiresRegistration,
    );
  }

  @override
  List<Object?> get props => [status, overview, message, requiresRegistration];
}
