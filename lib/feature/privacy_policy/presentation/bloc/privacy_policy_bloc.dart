import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/domain/repository/privacy_policy_repository.dart';

part 'privacy_policy_event.dart';
part 'privacy_policy_state.dart';

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  PrivacyPolicyBloc(this._repository) : super(const PrivacyPolicyState()) {
    on<PrivacyPolicyStarted>(_onStarted);
    on<PrivacyPolicyRetryRequested>(_onRetryRequested);
  }

  final PrivacyPolicyRepository _repository;

  Future<void> _onStarted(PrivacyPolicyStarted event, Emitter<PrivacyPolicyState> emit) async {
    emit(PrivacyPolicyState(status: PrivacyPolicyStatus.loading, markdown: state.markdown));
    try {
      final markdown = await _repository.loadMarkdown();
      emit(PrivacyPolicyState(status: PrivacyPolicyStatus.success, markdown: markdown));
    } catch (_) {
      emit(const PrivacyPolicyState(status: PrivacyPolicyStatus.failure, messageKey: PrivacyPolicyFailureMessage.loadFailed));
    }
  }

  Future<void> _onRetryRequested(PrivacyPolicyRetryRequested event, Emitter<PrivacyPolicyState> emit) async {
    add(const PrivacyPolicyStarted());
  }
}
