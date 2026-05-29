part of 'referral_bloc.dart';

sealed class ReferralEvent extends Equatable {
  const ReferralEvent();
}

class ReferralStarted extends ReferralEvent {
  const ReferralStarted();

  @override
  List<Object?> get props => [];
}

class ReferralRetryRequested extends ReferralEvent {
  const ReferralRetryRequested();

  @override
  List<Object?> get props => [];
}
