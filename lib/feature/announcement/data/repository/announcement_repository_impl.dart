import 'package:qizlar_academy_mobile/feature/announcement/data/datasource/announcement_datasource.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/repository/announcement_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl({
    required AnnouncementDatasource datasource,
    required AuthSessionCubit authSessionCubit,
  }) : _datasource = datasource,
       _authSessionCubit = authSessionCubit;

  final AnnouncementDatasource _datasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (!_authSessionCubit.state.isRegistered) {
      throw StateError(
        'Announcements are available only for registered users.',
      );
    }
  }

  @override
  Future<AnnouncementNextResult> fetchNext() {
    _ensureRegistered();
    return _datasource.fetchNext();
  }

  @override
  Future<void> markClicked(String viewId) {
    _ensureRegistered();
    return _datasource.markClicked(viewId);
  }
}
