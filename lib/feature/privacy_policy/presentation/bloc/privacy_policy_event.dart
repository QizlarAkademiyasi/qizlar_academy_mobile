part of 'privacy_policy_bloc.dart';

sealed class PrivacyPolicyEvent extends Equatable {
  const PrivacyPolicyEvent();

  @override
  List<Object?> get props => [];
}

class PrivacyPolicyStarted extends PrivacyPolicyEvent {
  const PrivacyPolicyStarted();
}

class PrivacyPolicyRetryRequested extends PrivacyPolicyEvent {
  const PrivacyPolicyRetryRequested();
}
