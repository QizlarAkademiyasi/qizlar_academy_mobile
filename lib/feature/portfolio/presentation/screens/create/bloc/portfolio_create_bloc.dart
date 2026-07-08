import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

part 'portfolio_create_event.dart';
part 'portfolio_create_state.dart';

class PortfolioCreateBloc
    extends Bloc<PortfolioCreateEvent, PortfolioCreateState> {
  PortfolioCreateBloc(this._repository) : super(const PortfolioCreateState()) {
    on<PortfolioCreateCaptionChanged>(_onCaptionChanged);
    on<PortfolioCreateMediaAdded>(_onMediaAdded);
    on<PortfolioCreateMediaRemoved>(_onMediaRemoved);
    on<PortfolioCreateSubmitted>(_onSubmitted);
  }

  final PortfolioRepository _repository;

  void _onCaptionChanged(
    PortfolioCreateCaptionChanged event,
    Emitter<PortfolioCreateState> emit,
  ) {
    emit(
      state.copyWith(
        caption: event.caption,
        status: PortfolioCreateStatus.editing,
        clearMessage: true,
      ),
    );
  }

  void _onMediaAdded(
    PortfolioCreateMediaAdded event,
    Emitter<PortfolioCreateState> emit,
  ) {
    final next = List<PortfolioPickedMedia>.from(state.media)
      ..add(
        PortfolioPickedMedia(
          localFilePath: event.localFilePath,
          type: event.type,
        ),
      );
    emit(
      state.copyWith(
        media: next,
        status: PortfolioCreateStatus.editing,
        clearMessage: true,
      ),
    );
  }

  void _onMediaRemoved(
    PortfolioCreateMediaRemoved event,
    Emitter<PortfolioCreateState> emit,
  ) {
    final next = List<PortfolioPickedMedia>.from(state.media)
      ..removeAt(event.index);
    emit(state.copyWith(media: next, status: PortfolioCreateStatus.editing));
  }

  Future<void> _onSubmitted(
    PortfolioCreateSubmitted event,
    Emitter<PortfolioCreateState> emit,
  ) async {
    if (state.media.isEmpty) {
      emit(
        state.copyWith(
          status: PortfolioCreateStatus.failure,
          message: 'Kamida bitta rasm yoki video qo\'shing',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: PortfolioCreateStatus.submitting,
        clearMessage: true,
      ),
    );
    try {
      final inputs = <PortfolioCreateMediaInput>[];
      for (var i = 0; i < state.media.length; i++) {
        final item = state.media[i];
        final uploadedUrl = await _repository.uploadMedia(item.localFilePath);
        inputs.add(
          PortfolioCreateMediaInput(
            type: item.type,
            url: uploadedUrl,
            thumbnail: null,
            duration: null,
            orderIndex: i,
          ),
        );
      }
      await _repository.createPost(caption: state.caption, media: inputs);
      emit(state.copyWith(status: PortfolioCreateStatus.success));
    } catch (e, st) {
      AppLogger.e(
        'PortfolioCreateBloc: submit failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          status: PortfolioCreateStatus.failure,
          message: 'Portfolio joylashda xatolik yuz berdi',
        ),
      );
    }
  }
}
