import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_us_page_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/repository/about_us_repository.dart';

part 'about_us_event.dart';
part 'about_us_state.dart';

class AboutUsBloc extends Bloc<AboutUsEvent, AboutUsState> {
  AboutUsBloc(this._repository) : super(const AboutUsState()) {
    on<AboutUsStarted>(_onStarted);
    on<AboutUsRetryRequested>(_onRetryRequested);
  }

  final AboutUsRepository _repository;

  Future<void> _onStarted(AboutUsStarted event, Emitter<AboutUsState> emit) async {
    emit(AboutUsState(status: AboutUsStatus.loading, content: state.content));
    try {
      final content = await _repository.loadAboutUs();
      emit(AboutUsState(status: AboutUsStatus.success, content: content));
    } catch (_) {
      emit(const AboutUsState(status: AboutUsStatus.failure, messageKey: AboutUsFailureMessage.loadFailed));
    }
  }

  Future<void> _onRetryRequested(AboutUsRetryRequested event, Emitter<AboutUsState> emit) async {
    add(const AboutUsStarted());
  }
}

