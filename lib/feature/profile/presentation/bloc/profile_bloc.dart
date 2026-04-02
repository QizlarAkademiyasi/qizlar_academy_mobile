import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
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
  }

  final ProfileRepository _repository;

  Future<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading, message: null, requiresRegistration: false));
    try {
      final overview = await _repository.getProfileOverview();
      emit(state.copyWith(status: ProfileStatus.success, overview: overview, requiresRegistration: false));
    } on ProfileRegistrationRequiredException {
      emit(state.copyWith(status: ProfileStatus.failure, requiresRegistration: true, message: null));
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure, requiresRegistration: false, message: 'Profil ma\'lumotlarini yuklashda xatolik.'));
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
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure, overview: current, requiresRegistration: false, message: 'Bildirishnomani yangilashda xatolik.'));
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
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure, overview: current, requiresRegistration: false, message: 'Tungi rejimni yangilashda xatolik.'));
    }
  }
}
