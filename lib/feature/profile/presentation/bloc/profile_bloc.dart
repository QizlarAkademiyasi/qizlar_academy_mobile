import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/exception/profile_registration_required_exception.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRetryRequested>(_onRetryRequested);
    on<ProfileNotificationsToggled>(_onNotificationsToggled);
    on<ProfileDarkModeToggled>(_onDarkModeToggled);
    on<ProfileBadgeSelected>(_onBadgeSelected);
  }

  final ProfileRepository _repository;

  Future<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading, message: null, requiresRegistration: false));
    try {
      final overview = await _repository.getProfileOverview();
      emit(state.copyWith(status: ProfileStatus.success, overview: overview, requiresRegistration: false));
    } on ProfileRegistrationRequiredException {
      emit(state.copyWith(status: ProfileStatus.failure, requiresRegistration: true, message: null));
    } catch (e, st) {
      AppLogger.e('ProfileBloc: overview load failed', error: e, stackTrace: st);
      emit(state.copyWith(status: ProfileStatus.failure, requiresRegistration: false, message: null));
    }
  }

  Future<void> _onRetryRequested(ProfileRetryRequested event, Emitter<ProfileState> emit) async {
    add(const ProfileStarted());
  }

  Future<void> _onNotificationsToggled(ProfileNotificationsToggled event, Emitter<ProfileState> emit) async {
    final current = state.overview;
    if (current == null || current.notificationsEnabled == event.enabled) {
      return;
    }
    emit(
      state.copyWith(
        status: ProfileStatus.updating,
        overview: current.copyWith(notificationsEnabled: event.enabled),
        message: null,
      ),
    );
    try {
      final updated = await _repository.updateNotifications(enabled: event.enabled);
      emit(state.copyWith(status: ProfileStatus.success, overview: updated));
    } catch (e, st) {
      AppLogger.e('ProfileBloc: notifications toggle failed', error: e, stackTrace: st);
      emit(state.copyWith(status: ProfileStatus.failure, overview: current, requiresRegistration: false, message: null));
    }
  }

  Future<void> _onDarkModeToggled(ProfileDarkModeToggled event, Emitter<ProfileState> emit) async {
    final current = state.overview;
    if (current == null || current.darkModeEnabled == event.enabled) {
      return;
    }
    emit(
      state.copyWith(
        status: ProfileStatus.updating,
        overview: current.copyWith(darkModeEnabled: event.enabled),
        message: null,
      ),
    );
    try {
      final updated = await _repository.updateDarkMode(enabled: event.enabled);
      emit(state.copyWith(status: ProfileStatus.success, overview: updated));
    } catch (e, st) {
      AppLogger.e('ProfileBloc: dark mode toggle failed', error: e, stackTrace: st);
      emit(state.copyWith(status: ProfileStatus.failure, overview: current, requiresRegistration: false, message: null));
    }
  }

  Future<void> _onBadgeSelected(ProfileBadgeSelected event, Emitter<ProfileState> emit) async {
    final current = state.overview;
    if (current == null || current.user.badgeId == event.badgeId) {
      return;
    }
    final baselineUser = current.user;
    final optimisticUser = ProfileUserModel(
      firstName: baselineUser.firstName,
      lastName: baselineUser.lastName,
      fullName: baselineUser.fullName,
      userId: baselineUser.userId,
      phoneNumber: baselineUser.phoneNumber,
      avatarUrl: baselineUser.avatarUrl,
      occupation: baselineUser.occupation,
      badgeId: event.badgeId,
    );
    emit(
      state.copyWith(
        status: ProfileStatus.updating,
        overview: current.copyWith(user: optimisticUser),
        message: null,
      ),
    );
    try {
      final updated = await _repository.patchMyProfileIfChanged(
        baseline: baselineUser,
        firstName: baselineUser.firstName,
        lastName: baselineUser.lastName,
        occupation: baselineUser.occupation,
        uploadedPhotoFilename: null,
        selectedBadgeId: event.badgeId,
      );
      if (updated != null) {
        emit(state.copyWith(status: ProfileStatus.success, overview: updated));
      } else {
        emit(state.copyWith(status: ProfileStatus.success, overview: current.copyWith(user: optimisticUser)));
      }
    } catch (e, st) {
      AppLogger.e('ProfileBloc: badge update failed', error: e, stackTrace: st);
      emit(state.copyWith(status: ProfileStatus.failure, overview: current.copyWith(user: baselineUser), requiresRegistration: false, message: null));
    }
  }
}
