part of 'privacy_policy_bloc.dart';

enum PrivacyPolicyStatus { initial, loading, success, failure }

enum PrivacyPolicyFailureMessage { loadFailed }

class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState({this.status = PrivacyPolicyStatus.initial, this.markdown, this.messageKey});

  final PrivacyPolicyStatus status;
  final String? markdown;
  final PrivacyPolicyFailureMessage? messageKey;

  @override
  List<Object?> get props => [status, markdown, messageKey];
}
