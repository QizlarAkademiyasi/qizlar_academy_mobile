import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/my_certificates_repository.dart';

part 'my_certificates_event.dart';
part 'my_certificates_state.dart';

class MyCertificatesBloc extends Bloc<MyCertificatesEvent, MyCertificatesState> {
  MyCertificatesBloc(this._repository) : super(const MyCertificatesState()) {
    on<MyCertificatesStarted>(_onStarted);
    on<MyCertificatesRetryRequested>(_onRetryRequested);
  }

  final MyCertificatesRepository _repository;

  Future<void> _onStarted(MyCertificatesStarted event, Emitter<MyCertificatesState> emit) async {
    emit(MyCertificatesState(status: MyCertificatesStatus.loading, items: state.items));
    try {
      final items = await _repository.fetchMyCertificates();
      emit(MyCertificatesState(status: MyCertificatesStatus.success, items: items));
    } catch (_) {
      emit(const MyCertificatesState(status: MyCertificatesStatus.failure));
    }
  }

  Future<void> _onRetryRequested(MyCertificatesRetryRequested event, Emitter<MyCertificatesState> emit) async {
    add(const MyCertificatesStarted());
  }
}
