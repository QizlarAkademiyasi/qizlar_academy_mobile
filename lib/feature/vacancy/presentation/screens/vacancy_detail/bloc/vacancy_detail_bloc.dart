import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/repository/vacancy_repository.dart';

part 'vacancy_detail_event.dart';
part 'vacancy_detail_state.dart';

class VacancyDetailBloc extends Bloc<VacancyDetailEvent, VacancyDetailState> {
  VacancyDetailBloc(this._repository) : super(const VacancyDetailState()) {
    on<VacancyDetailStarted>(_onStarted);
  }

  final VacancyRepository _repository;

  Future<void> _onStarted(VacancyDetailStarted event, Emitter<VacancyDetailState> emit) async {
    emit(state.copyWith(status: VacancyDetailStatus.loading, clearDetail: true, clearMessage: true));
    try {
      final detail = await _repository.fetchById(event.vacancyId);
      emit(state.copyWith(status: VacancyDetailStatus.success, detail: detail));
    } catch (e, st) {
      AppLogger.e('VacancyDetailBloc: fetch failed', error: e, stackTrace: st);
      emit(state.copyWith(status: VacancyDetailStatus.failure, message: e.toString()));
    }
  }
}
