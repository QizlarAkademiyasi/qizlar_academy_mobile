part of 'about_us_bloc.dart';

enum AboutUsStatus { initial, loading, success, failure }

enum AboutUsFailureMessage { loadFailed }

class AboutUsState extends Equatable {
  const AboutUsState({this.status = AboutUsStatus.initial, this.content, this.messageKey});

  final AboutUsStatus status;
  final AboutUsPageModel? content;
  final AboutUsFailureMessage? messageKey;

  @override
  List<Object?> get props => [status, content, messageKey];
}
