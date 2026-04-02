part of 'my_certificates_bloc.dart';

sealed class MyCertificatesEvent extends Equatable {
  const MyCertificatesEvent();

  @override
  List<Object?> get props => [];
}

final class MyCertificatesStarted extends MyCertificatesEvent {
  const MyCertificatesStarted();
}

final class MyCertificatesRetryRequested extends MyCertificatesEvent {
  const MyCertificatesRetryRequested();
}
