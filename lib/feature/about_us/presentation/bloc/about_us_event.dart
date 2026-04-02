part of 'about_us_bloc.dart';

sealed class AboutUsEvent extends Equatable {
  const AboutUsEvent();

  @override
  List<Object?> get props => [];
}

final class AboutUsStarted extends AboutUsEvent {
  const AboutUsStarted();
}

final class AboutUsRetryRequested extends AboutUsEvent {
  const AboutUsRetryRequested();
}
